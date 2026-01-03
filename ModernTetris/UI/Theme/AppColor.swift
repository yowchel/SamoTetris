//
//  AppColor.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// App color definitions - Theme-aware
extension Color {
    // Get current theme from UserDefaults
    private static var currentTheme: GameTheme {
        let themeName = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Viking"
        return GameTheme(rawValue: themeName) ?? .viking
    }

    // Theme-aware UI Colors
    static var vikingBackground: Color { currentTheme.background }
    static var vikingWood: Color { currentTheme.wood }
    static var vikingStone: Color { currentTheme.stone }
    static var vikingGold: Color { currentTheme.primaryAccent }
    static var vikingAccent: Color { currentTheme.secondaryAccent }

    // Board Colors
    static var boardBackground: Color { currentTheme.boardBackground }
    static var cellBorder: Color { currentTheme.cellBorder }
    static var emptyCell: Color { currentTheme.emptyCell }

    /// Get color for tetromino type using current theme
    static func forTetromino(_ type: TetrominoType) -> Color {
        return currentTheme.colorForTetromino(type)
    }
}
