//
//  AppColor.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// App color definitions
extension Color {
    // Tetromino colors (vibrant gradients)
    static let tetrominoI = Color(red: 0.0, green: 0.75, blue: 0.95)  // Cyan
    static let tetrominoO = Color(red: 0.95, green: 0.85, blue: 0.0)  // Yellow
    static let tetrominoT = Color(red: 0.75, green: 0.0, blue: 0.95)  // Purple
    static let tetrominoS = Color(red: 0.0, green: 0.95, blue: 0.3)   // Green
    static let tetrominoZ = Color(red: 0.95, green: 0.0, blue: 0.0)   // Red
    static let tetrominoJ = Color(red: 0.0, green: 0.3, blue: 0.95)   // Blue
    static let tetrominoL = Color(red: 0.95, green: 0.55, blue: 0.0)  // Orange

    // UI Colors
    static let boardBackground = Color(white: 0.15)
    static let cellBorder = Color(white: 0.25)
    static let emptyCell = Color(white: 0.2)

    /// Get color for tetromino type
    static func forTetromino(_ type: TetrominoType) -> Color {
        switch type {
        case .i: return .tetrominoI
        case .o: return .tetrominoO
        case .t: return .tetrominoT
        case .s: return .tetrominoS
        case .z: return .tetrominoZ
        case .j: return .tetrominoJ
        case .l: return .tetrominoL
        }
    }
}
