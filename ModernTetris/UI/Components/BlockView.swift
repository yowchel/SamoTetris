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
            // Filled block - 3D game style with highlights and shadows
            ZStack {
                // Main block body with gradient
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.forTetromino(type).opacity(0.95),
                                Color.forTetromino(type),
                                Color.forTetromino(type).opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Top-left highlight (creates 3D effect)
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .padding(size * 0.04)

                // Bottom-right shadow (creates depth)
                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.black.opacity(0.25)
                            ],
                            startPoint: .center,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(size * 0.04)

                // Outer border - thin and crisp
                RoundedRectangle(cornerRadius: size * 0.12)
                    .strokeBorder(Color.black.opacity(0.6), lineWidth: 1)
            }
            .frame(width: size, height: size)
            .shadow(color: Color.black.opacity(0.3), radius: 1.5, x: 0, y: 1.5)
        } else {
            // Empty cell - with grid lines
            Rectangle()
                .fill(Color.emptyCell)
                .frame(width: size, height: size)
                .overlay(
                    Rectangle()
                        .strokeBorder(Color.cellBorder, lineWidth: 0.5)
                )
        }
    }
}
