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
        let themeName = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Noir"
        return GameTheme(rawValue: themeName) ?? .noir
    }

    // Theme-aware UI Colors
    static var vikingBackground: Color { currentTheme.background }
    static var vikingWood: Color { currentTheme.wood }
    static var vikingStone: Color { currentTheme.stone }
    static var vikingGold: Color { currentTheme.primaryAccent }
    static var vikingAccent: Color { currentTheme.secondaryAccent }

    // UI Element Colors
    static var buttonGray: Color { currentTheme.buttonGray }
    static var successColor: Color { currentTheme.successColor }
    static var dangerColor: Color { currentTheme.dangerColor }

    // Menu Button Colors
    static var playButtonColor: Color { currentTheme.playButtonColor }
    static var shopButtonColor: Color { currentTheme.shopButtonColor }
    static var leaderboardButtonColor: Color { currentTheme.leaderboardButtonColor }
    static var settingsButtonColor: Color { currentTheme.settingsButtonColor }

    // Menu Button Text Colors
    static var playButtonTextColor: Color { currentTheme.playButtonTextColor }
    static var shopButtonTextColor: Color { currentTheme.shopButtonTextColor }
    static var leaderboardButtonTextColor: Color { currentTheme.leaderboardButtonTextColor }
    static var settingsButtonTextColor: Color { currentTheme.settingsButtonTextColor }

    // Text Colors
    static var primaryText: Color { currentTheme.primaryText }
    static var secondaryText: Color { currentTheme.secondaryText }
    static var titleText: Color { currentTheme.titleText }

    // Board Colors
    static var boardBackground: Color { currentTheme.boardBackground }
    static var cellBorder: Color { currentTheme.cellBorder }
    static var emptyCell: Color { currentTheme.emptyCell }

    /// Get color for tetromino type using current theme
    static func forTetromino(_ type: TetrominoType) -> Color {
        return currentTheme.colorForTetromino(type)
    }
}
