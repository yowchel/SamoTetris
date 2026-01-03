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
    let blockSize: CGFloat

    var body: some View {
        ZStack {
            // Background
            Color.boardBackground

            // Grid
            VStack(spacing: 0) {
                ForEach(0..<board.height, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<board.width, id: \.self) { col in
                            let position = Position(row: row, column: col)
                            let cellType = cellTypeAt(position)
                            BlockView(type: cellType, size: blockSize)
                        }
                    }
                }
            }
        }
        .cornerRadius(12)
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
}
