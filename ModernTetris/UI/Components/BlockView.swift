//
//  BlockView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Displays a single tetromino block
struct BlockView: View {
    let type: TetrominoType?
    let size: CGFloat

    var body: some View {
        if let type = type {
            // Filled block - Viking rune stone style
            ZStack {
                // Main block
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.forTetromino(type),
                                Color.forTetromino(type).opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Inner highlight
                RoundedRectangle(cornerRadius: size * 0.12)
                    .stroke(Color.white.opacity(0.25), lineWidth: size * 0.08)
                    .padding(size * 0.08)

                // Border
                RoundedRectangle(cornerRadius: size * 0.12)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1)
            }
            .frame(width: size, height: size)
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
        } else {
            // Empty cell - stone floor
            RoundedRectangle(cornerRadius: size * 0.12)
                .fill(Color.emptyCell)
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.12)
                        .stroke(Color.cellBorder, lineWidth: 0.5)
                )
        }
    }
}
