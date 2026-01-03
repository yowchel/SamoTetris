//
//  TetrisBoard.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Represents the game board state
struct TetrisBoard {
    private var grid: [[TetrominoType?]]

    let width = GameConstants.boardWidth
    let height = GameConstants.boardHeight

    init() {
        // Initialize empty grid
        grid = Array(repeating: Array(repeating: nil, count: GameConstants.boardWidth),
                    count: GameConstants.boardHeight)
    }

    /// Get cell at position (nil if empty or out of bounds)
    subscript(position: Position) -> TetrominoType? {
        get {
            guard isValid(position: position) else { return nil }
            return grid[position.row][position.column]
        }
        set {
            guard isValid(position: position) else { return }
            grid[position.row][position.column] = newValue
        }
    }

    /// Check if position is within board bounds
    func isValid(position: Position) -> Bool {
        return position.row >= 0 &&
               position.row < height &&
               position.column >= 0 &&
               position.column < width
    }

    /// Check if a piece can be placed at its current position
    func canPlace(_ piece: Tetromino) -> Bool {
        for block in piece.blocks {
            // Out of bounds check
            if !isValid(position: block) {
                return false
            }

            // Collision with existing blocks
            if self[block] != nil {
                return false
            }
        }
        return true
    }

    /// Place a piece on the board (locks it in place)
    mutating func place(_ piece: Tetromino) {
        for block in piece.blocks {
            self[block] = piece.type
        }
    }

    /// Check for full lines and return their indices
    func fullLines() -> [Int] {
        var lines: [Int] = []

        for row in 0..<height {
            var isFull = true
            for col in 0..<width {
                if grid[row][col] == nil {
                    isFull = false
                    break
                }
            }
            if isFull {
                lines.append(row)
            }
        }

        return lines
    }

    /// Clear specified lines and drop blocks above
    mutating func clearLines(_ lines: [Int]) {
        guard !lines.isEmpty else { return }

        let sortedLines = lines.sorted(by: >)

        for line in sortedLines {
            // Remove the line
            grid.remove(at: line)

            // Add empty line at top
            grid.insert(Array(repeating: nil, count: width), at: 0)
        }
    }

    /// Check if game is over (blocks in top row)
    func isGameOver() -> Bool {
        for col in 0..<width {
            if grid[0][col] != nil {
                return true
            }
        }
        return false
    }

    /// Get all occupied positions for rendering
    func occupiedPositions() -> [(Position, TetrominoType)] {
        var positions: [(Position, TetrominoType)] = []

        for row in 0..<height {
            for col in 0..<width {
                if let type = grid[row][col] {
                    positions.append((Position(row: row, column: col), type))
                }
            }
        }

        return positions
    }

    /// Reset board to empty state
    mutating func reset() {
        grid = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
}
