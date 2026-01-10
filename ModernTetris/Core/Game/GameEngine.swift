//
//  GameEngine.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI
import Combine

/// Main game engine - manages game state and logic
@MainActor
final class GameEngine: ObservableObject {
    @Published private(set) var board = TetrisBoard()
    @Published private(set) var currentPiece: Tetromino?
    @Published private(set) var heldPiece: Tetromino?
    @Published private(set) var nextPieces: [TetrominoType] = []
    @Published private(set) var state: GameState = .idle
    @Published private(set) var score: Int = 0
    @Published private(set) var linesCleared: Int = 0
    @Published private(set) var tetrisCount: Int = 0
    @Published private(set) var clearingLines: Set<Int> = []  // Lines currently being cleared with animation

    private var pieceGenerator = PieceGenerator()
    private var gameTimer: Timer?
    private var canHold = true  // Prevents double-hold
    private var isAnimating = false  // Prevents new piece locks during line clear animation
    private let audioManager = AudioManager.shared

    /// Ghost piece shows where current piece will land
    var ghostPiece: Tetromino? {
        guard let piece = currentPiece else { return nil }
        var ghost = piece
        while board.canPlace(ghost.movedDown()) {
            ghost = ghost.movedDown()
        }
        return ghost
    }

    // MARK: - Game Control

    /// Start new game
    func start() {
        reset()
        state = .playing
        spawnNewPiece()
        startTimer()
    }

    /// Pause game
    func pause() {
        guard state == .playing else { return }
        state = .paused
        stopTimer()
    }

    /// Resume game
    func resume() {
        guard state == .paused else { return }
        state = .playing
        startTimer()
    }

    /// End game
    func gameOver() {
        state = .gameOver
        stopTimer()

        // Play game over sound
        audioManager.gameOver()

        // Award coins for the game
        let coinsEarned = CurrencyManager.shared.awardGameCoins(
            score: score,
            linesCleared: linesCleared,
            tetrisCount: tetrisCount
        )

        // Update stats
        updateStats()

        print("Game Over! Earned \(coinsEarned) coins. Total: \(CurrencyManager.shared.coins)")
    }

    /// Reset game state
    private func reset() {
        board.reset()
        pieceGenerator.reset()
        currentPiece = nil
        heldPiece = nil
        nextPieces = []
        score = 0
        linesCleared = 0
        tetrisCount = 0
        canHold = true
        isAnimating = false
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        gameTimer = Timer.scheduledTimer(withTimeInterval: GameConstants.dropInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    /// Game tick - move piece down automatically
    private func tick() {
        guard state == .playing else { return }
        moveDown()
    }

    // MARK: - Piece Spawning

    private func spawnNewPiece() {
        let type = pieceGenerator.next()
        let piece = Tetromino(
            type: type,
            position: Position(row: GameConstants.startRow, column: GameConstants.startColumn)
        )

        // Check if piece can spawn (game over if not)
        if !board.canPlace(piece) {
            gameOver()
            return
        }

        currentPiece = piece
        nextPieces = pieceGenerator.preview()
        canHold = true  // Can hold again after spawning new piece
    }

    // MARK: - Piece Movement

    /// Move piece left
    func moveLeft() {
        guard state == .playing, let piece = currentPiece else { return }
        let moved = piece.movedLeft()
        if board.canPlace(moved) {
            currentPiece = moved
            audioManager.pieceMoved()
        }
    }

    /// Move piece right
    func moveRight() {
        guard state == .playing, let piece = currentPiece else { return }
        let moved = piece.movedRight()
        if board.canPlace(moved) {
            currentPiece = moved
            audioManager.pieceMoved()
        }
    }

    /// Move piece down (soft drop) - returns points earned
    @discardableResult
    func moveDown() -> Int {
        guard state == .playing, let piece = currentPiece else { return 0 }
        let moved = piece.movedDown()

        if board.canPlace(moved) {
            currentPiece = moved
            return 0
        } else {
            // Piece can't move down - lock it
            lockPiece()
            return 0
        }
    }

    /// Soft drop (hold down) - moves down and awards points
    func softDrop() -> Int {
        guard state == .playing, let piece = currentPiece else { return 0 }
        var dropDistance = 0
        var testPiece = piece

        // Move down until can't
        while board.canPlace(testPiece.movedDown()) {
            testPiece = testPiece.movedDown()
            dropDistance += 1
        }

        if dropDistance > 0 {
            currentPiece = testPiece
            let points = ScoreManager.scoreForSoftDrop(cells: dropDistance)
            score += points
            return points
        }

        return 0
    }

    /// Hard drop - instantly drop to bottom
    func hardDrop() {
        guard state == .playing, let piece = currentPiece else { return }
        var dropDistance = 0
        var testPiece = piece

        // Find bottom position
        while board.canPlace(testPiece.movedDown()) {
            testPiece = testPiece.movedDown()
            dropDistance += 1
        }

        currentPiece = testPiece

        // Award points
        let points = ScoreManager.scoreForHardDrop(cells: dropDistance)
        score += points

        // Lock immediately
        lockPiece()
    }

    /// Rotate piece clockwise
    func rotate() {
        guard state == .playing, let piece = currentPiece else { return }
        let rotated = piece.rotated()
        if board.canPlace(rotated) {
            currentPiece = rotated
            audioManager.pieceRotated()
        }
    }

    /// Hold current piece
    func hold() {
        guard state == .playing, canHold, let piece = currentPiece else { return }

        if let held = heldPiece {
            // Swap current with held
            let newPiece = Tetromino(
                type: held.type,
                position: Position(row: GameConstants.startRow, column: GameConstants.startColumn)
            )

            if board.canPlace(newPiece) {
                heldPiece = Tetromino(type: piece.type)
                currentPiece = newPiece
                canHold = false
                audioManager.pieceHeld()
            }
        } else {
            // First hold
            heldPiece = Tetromino(type: piece.type)
            spawnNewPiece()
            canHold = false
            audioManager.pieceHeld()
        }
    }

    // MARK: - Piece Locking

    private func lockPiece() {
        guard let piece = currentPiece else { return }

        // Don't lock if animation is in progress
        guard !isAnimating else { return }

        // Place piece on board
        board.place(piece)
        currentPiece = nil

        // Play lock sound
        audioManager.pieceLocked()

        // Check for line clears
        let fullLines = board.fullLines()

        if !fullLines.isEmpty {
            // Block new locks during animation
            isAnimating = true

            // Mark lines for clearing animation
            clearingLines = Set(fullLines)

            // Play appropriate sound based on line count
            let lineCount = fullLines.count
            if ScoreManager.isTetris(lineCount: lineCount) {
                audioManager.tetris()
            } else {
                audioManager.lineCleared()
            }

            // Animate line clear
            Task { @MainActor in
                // Wait for animation (0.6 seconds to match particle effects)
                try? await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds

                // Clear lines
                board.clearLines(fullLines)
                clearingLines = []

                // Update stats
                linesCleared += lineCount

                // Award points
                let points = ScoreManager.scoreForLines(count: lineCount)
                score += points

                // Track Tetris
                if ScoreManager.isTetris(lineCount: lineCount) {
                    tetrisCount += 1
                }

                // Animation done
                isAnimating = false

                // Check game over
                if board.isGameOver() {
                    gameOver()
                    return
                }

                // Spawn next piece
                spawnNewPiece()
            }
        } else {
            // No lines to clear - spawn immediately
            // Check game over
            if board.isGameOver() {
                gameOver()
                return
            }

            // Spawn next piece
            spawnNewPiece()
        }
    }

    // MARK: - Stats

    /// Update game statistics
    private func updateStats() {
        // Get current stats
        let currentHighScore = UserDefaults.standard.integer(forKey: "highScore")
        let currentTotalGames = UserDefaults.standard.integer(forKey: "totalGames")
        let currentTotalLines = UserDefaults.standard.integer(forKey: "totalLines")

        // Update high score
        if score > currentHighScore {
            UserDefaults.standard.set(score, forKey: "highScore")
        }

        // Update total games
        UserDefaults.standard.set(currentTotalGames + 1, forKey: "totalGames")

        // Update total lines
        UserDefaults.standard.set(currentTotalLines + linesCleared, forKey: "totalLines")
    }
}
