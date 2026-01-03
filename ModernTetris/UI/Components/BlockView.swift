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
            // Filled block
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(Color.forTetromino(type))
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.15)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                )
        } else {
            // Empty cell
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(Color.emptyCell)
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.15)
                        .stroke(Color.cellBorder, lineWidth: 0.5)
                )
        }
    }
}
