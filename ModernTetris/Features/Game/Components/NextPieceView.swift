//
//  NextPieceView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Displays preview of next pieces
struct NextPieceView: View {
    let pieces: [TetrominoType]
    let blockSize: CGFloat

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(pieces.prefix(3).enumerated()), id: \.offset) { index, type in
                miniPieceView(type: type)
                    .opacity(index == 0 ? 1.0 : 0.7)
            }
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
