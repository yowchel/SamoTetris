//
//  ThemeManager.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Available game themes
enum GameTheme: String, CaseIterable, Hashable {
    case viking = "Viking"
    case neon = "Neon"
    case metal = "Metal"
    case noir = "Noir"

    var displayName: String {
        return self.rawValue
    }
}

/// Theme color sets
extension GameTheme {
    // Background colors
    var background: Color {
        switch self {
        case .viking: return Color(red: 0.12, green: 0.1, blue: 0.15)
        case .neon: return Color(red: 0.05, green: 0.05, blue: 0.12)
        case .metal: return Color(red: 0.15, green: 0.15, blue: 0.18)
        case .noir: return Color(red: 0.08, green: 0.08, blue: 0.08)
        }
    }

    var wood: Color {
        switch self {
        case .viking: return Color(red: 0.35, green: 0.25, blue: 0.2)
        case .neon: return Color(red: 0.1, green: 0.1, blue: 0.2)
        case .metal: return Color(red: 0.25, green: 0.25, blue: 0.28)
        case .noir: return Color(red: 0.18, green: 0.18, blue: 0.18)
        }
    }

    var stone: Color {
        switch self {
        case .viking: return Color(red: 0.25, green: 0.25, blue: 0.28)
        case .neon: return Color(red: 0.08, green: 0.08, blue: 0.15)
        case .metal: return Color(red: 0.3, green: 0.3, blue: 0.35)
        case .noir: return Color(red: 0.22, green: 0.22, blue: 0.22)
        }
    }

    var primaryAccent: Color {
        switch self {
        case .viking: return Color(red: 0.85, green: 0.7, blue: 0.3)  // Gold
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)     // Cyan
        case .metal: return Color(red: 0.7, green: 0.85, blue: 1.0)   // Steel Blue
        case .noir: return Color(red: 0.9, green: 0.9, blue: 0.9)     // White
        }
    }

    var secondaryAccent: Color {
        switch self {
        case .viking: return Color(red: 0.4, green: 0.7, blue: 0.85)  // Ice Blue
        case .neon: return Color(red: 1.0, green: 0.0, blue: 0.8)     // Magenta
        case .metal: return Color(red: 0.9, green: 0.7, blue: 0.3)    // Bronze
        case .noir: return Color(red: 0.7, green: 0.7, blue: 0.7)     // Light Gray
        }
    }

    // UI Element colors
    var buttonGray: Color {
        switch self {
        case .viking: return Color(red: 0.45, green: 0.45, blue: 0.5)
        case .neon: return Color(red: 0.2, green: 0.2, blue: 0.4)
        case .metal: return Color(red: 0.4, green: 0.4, blue: 0.45)
        case .noir: return Color(red: 0.35, green: 0.35, blue: 0.35)
        }
    }

    var successColor: Color {
        switch self {
        case .viking: return Color(red: 0.3, green: 0.8, blue: 0.5)    // Forest Green
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.5)      // Electric Green
        case .metal: return Color(red: 0.5, green: 0.85, blue: 0.6)    // Metallic Green
        case .noir: return Color(red: 0.6, green: 0.6, blue: 0.6)      // Gray
        }
    }

    var dangerColor: Color {
        switch self {
        case .viking: return Color(red: 0.9, green: 0.25, blue: 0.25)  // Blood Red
        case .neon: return Color(red: 1.0, green: 0.1, blue: 0.4)      // Hot Pink
        case .metal: return Color(red: 0.9, green: 0.4, blue: 0.4)     // Brushed Red
        case .noir: return Color(red: 0.5, green: 0.5, blue: 0.5)      // Dark Gray
        }
    }

    // Text colors
    var primaryText: Color {
        switch self {
        case .viking: return Color(red: 0.95, green: 0.95, blue: 0.97)  // Off-white
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.9)       // Bright Cyan
        case .metal: return Color(red: 0.9, green: 0.95, blue: 1.0)     // Light Steel
        case .noir: return Color(red: 0.95, green: 0.95, blue: 0.95)    // Pure White
        }
    }

    var secondaryText: Color {
        switch self {
        case .viking: return Color(red: 0.7, green: 0.7, blue: 0.75)    // Muted White
        case .neon: return Color(red: 1.0, green: 0.4, blue: 1.0)       // Bright Magenta
        case .metal: return Color(red: 0.7, green: 0.8, blue: 0.9)      // Soft Steel
        case .noir: return Color(red: 0.7, green: 0.7, blue: 0.7)       // Light Gray
        }
    }

    var titleText: Color {
        switch self {
        case .viking: return self.primaryAccent  // Gold
        case .neon: return Color(red: 0.0, green: 1.0, blue: 1.0)  // Electric Cyan
        case .metal: return Color(red: 0.8, green: 0.95, blue: 1.0)  // Bright Steel
        case .noir: return Color(red: 1.0, green: 1.0, blue: 1.0)  // Pure White
        }
    }

    // Tetromino colors
    func colorForTetromino(_ type: TetrominoType) -> Color {
        switch self {
        case .viking:
            switch type {
            case .i: return Color(red: 0.2, green: 0.8, blue: 1.0)    // Bright Ice Blue
            case .o: return Color(red: 1.0, green: 0.85, blue: 0.2)   // Bright Gold
            case .t: return Color(red: 0.75, green: 0.25, blue: 0.95) // Vivid Purple
            case .s: return Color(red: 0.3, green: 0.95, blue: 0.5)   // Vibrant Green
            case .z: return Color(red: 1.0, green: 0.2, blue: 0.15)   // Bright Red
            case .j: return Color(red: 0.25, green: 0.55, blue: 1.0)  // Bright Blue
            case .l: return Color(red: 1.0, green: 0.65, blue: 0.15)  // Bright Orange
            }
        case .neon:
            switch type {
            case .i: return Color(red: 0.0, green: 0.95, blue: 1.0)   // Electric Cyan
            case .o: return Color(red: 1.0, green: 0.95, blue: 0.0)   // Electric Yellow
            case .t: return Color(red: 1.0, green: 0.15, blue: 1.0)   // Hot Pink
            case .s: return Color(red: 0.0, green: 1.0, blue: 0.35)   // Neon Green
            case .z: return Color(red: 1.0, green: 0.1, blue: 0.3)    // Neon Red
            case .j: return Color(red: 0.2, green: 0.6, blue: 1.0)    // Electric Blue
            case .l: return Color(red: 1.0, green: 0.5, blue: 0.0)    // Neon Orange
            }
        case .metal:
            switch type {
            case .i: return Color(red: 0.6, green: 0.9, blue: 1.0)    // Chrome Blue
            case .o: return Color(red: 1.0, green: 0.9, blue: 0.4)    // Polished Gold
            case .t: return Color(red: 0.85, green: 0.5, blue: 0.95)  // Metallic Purple
            case .s: return Color(red: 0.4, green: 0.85, blue: 0.65)  // Copper Green
            case .z: return Color(red: 0.95, green: 0.45, blue: 0.4)  // Brushed Red
            case .j: return Color(red: 0.45, green: 0.7, blue: 1.0)   // Steel Blue
            case .l: return Color(red: 1.0, green: 0.7, blue: 0.35)   // Bronze
            }
        case .noir:
            switch type {
            case .i: return Color(red: 1.0, green: 1.0, blue: 1.0)    // Pure White
            case .o: return Color(red: 0.9, green: 0.9, blue: 0.0)    // Film Yellow
            case .t: return Color(red: 0.85, green: 0.85, blue: 0.85) // Bright Gray
            case .s: return Color(red: 0.7, green: 0.7, blue: 0.7)    // Medium Gray
            case .z: return Color(red: 0.55, green: 0.55, blue: 0.55) // Slate Gray
            case .j: return Color(red: 0.4, green: 0.4, blue: 0.4)    // Charcoal
            case .l: return Color(red: 0.25, green: 0.25, blue: 0.25) // Deep Gray
            }
        }
    }

    // Board colors
    var boardBackground: Color {
        switch self {
        case .viking: return Color(red: 0.08, green: 0.08, blue: 0.12)
        case .neon: return Color(red: 0.02, green: 0.02, blue: 0.08)
        case .metal: return Color(red: 0.12, green: 0.12, blue: 0.15)
        case .noir: return Color(red: 0.05, green: 0.05, blue: 0.05)
        }
    }

    var cellBorder: Color {
        switch self {
        case .viking: return Color(white: 0.2, opacity: 0.3)
        case .neon: return Color(red: 0.0, green: 0.8, blue: 0.8, opacity: 0.2)
        case .metal: return Color(white: 0.4, opacity: 0.2)
        case .noir: return Color(white: 0.3, opacity: 0.4)
        }
    }

    var emptyCell: Color {
        switch self {
        case .viking: return Color(white: 0.15, opacity: 0.5)
        case .neon: return Color(red: 0.05, green: 0.05, blue: 0.15, opacity: 0.6)
        case .metal: return Color(white: 0.18, opacity: 0.5)
        case .noir: return Color(white: 0.12, opacity: 0.5)
        }
    }
}
