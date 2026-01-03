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
        VStack(alignment: .leading, spacing: 12) {
            Text("NEXT")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.7))

            VStack(spacing: 8) {
                ForEach(Array(pieces.prefix(3).enumerated()), id: \.offset) { index, type in
                    miniPieceView(type: type)
                        .opacity(index == 0 ? 1.0 : 0.6)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }

    private func miniPieceView(type: TetrominoType) -> some View {
        let blocks = type.baseBlocks
        let minRow = blocks.map { $0.row }.min() ?? 0
        let maxRow = blocks.map { $0.row }.max() ?? 0
        let minCol = blocks.map { $0.column }.min() ?? 0
        let maxCol = blocks.map { $0.column }.max() ?? 0

        let rows = maxRow - minRow + 1
        let cols = maxCol - minCol + 1

        return VStack(spacing: 2) {
            ForEach(minRow...maxRow, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(minCol...maxCol, id: \.self) { col in
                        let pos = Position(row: row, column: col)
                        if blocks.contains(pos) {
                            BlockView(type: type, size: blockSize * 0.5)
                        } else {
                            Color.clear
                                .frame(width: blockSize * 0.5, height: blockSize * 0.5)
                        }
                    }
                }
            }
        }
    }
}
