//
//  HoldPieceView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Displays the held piece
struct HoldPieceView: View {
    let piece: Tetromino?
    let blockSize: CGFloat

    var body: some View {
        if let piece = piece {
            miniPieceView(type: piece.type)
        } else {
            Color.clear
                .frame(width: blockSize * 4, height: blockSize * 4)
        }
    }

    private func miniPieceView(type: TetrominoType) -> some View {
        let blocks = type.baseBlocks
        let minRow = blocks.map { $0.row }.min() ?? 0
        let maxRow = blocks.map { $0.row }.max() ?? 0
        let minCol = blocks.map { $0.column }.min() ?? 0
        let maxCol = blocks.map { $0.column }.max() ?? 0

        return VStack(spacing: 2) {
            ForEach(minRow...maxRow, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(minCol...maxCol, id: \.self) { col in
                        let pos = Position(row: row, column: col)
                        if blocks.contains(pos) {
                            BlockView(type: type, size: blockSize)
                        } else {
                            Color.clear
                                .frame(width: blockSize, height: blockSize)
                        }
                    }
                }
            }
        }
    }
}
