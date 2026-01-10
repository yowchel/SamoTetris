//
//  BoardView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Displays the game board
struct BoardView: View {
    let board: TetrisBoard
    let currentPiece: Tetromino?
    let ghostPiece: Tetromino?
    let blockSize: CGFloat
    let clearingLines: Set<Int>

    var body: some View {
        ZStack {
            // Clean solid background
            Color.boardBackground

            // Grid
            VStack(spacing: 0) {
                ForEach(0..<board.height, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<board.width, id: \.self) { col in
                            let position = Position(row: row, column: col)
                            cellView(at: position)
                        }
                    }
                }
            }
            .padding(6)

            // Particle effects
            if let particleEffect = ShopManager.shared.currentParticleEffect {
                ParticleEffectView(
                    effect: particleEffect,
                    clearingLines: clearingLines,
                    blockSize: blockSize,
                    boardWidth: board.width
                )
                .padding(6)
            }
        }
    }

    @ViewBuilder
    private func cellView(at position: Position) -> some View {
        let cellType = cellTypeAt(position)
        let isGhost = isGhostAt(position)
        let isClearing = clearingLines.contains(position.row)

        if isGhost && cellType == nil {
            // Ghost piece - semi-transparent
            if let ghostType = ghostPiece?.type {
                BlockView(type: ghostType, size: blockSize)
                    .opacity(0.15)
            } else {
                BlockView(type: nil, size: blockSize)
            }
        } else {
            BlockView(type: cellType, size: blockSize)
                .opacity(isClearing ? 0.3 : 1.0)
                .scaleEffect(isClearing ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 0.15).repeatCount(2, autoreverses: true), value: isClearing)
        }
    }

    /// Get tetromino type at position (from board or current piece)
    private func cellTypeAt(_ position: Position) -> TetrominoType? {
        // Check if current piece occupies this position
        if let piece = currentPiece {
            for block in piece.blocks where block == position {
                return piece.type
            }
        }

        // Check board
        return board[position]
    }

    /// Check if ghost piece is at position
    private func isGhostAt(_ position: Position) -> Bool {
        guard let ghost = ghostPiece else { return false }
        return ghost.blocks.contains(position)
    }
}
