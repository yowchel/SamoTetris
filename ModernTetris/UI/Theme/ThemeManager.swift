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
    case sunset = "Sunset"
    case ocean = "Ocean"

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
        case .metal: return Color(red: 0.08, green: 0.1, blue: 0.12)  // Dark chrome gray
        case .noir: return Color(red: 0.08, green: 0.08, blue: 0.08)
        case .sunset: return Color(red: 0.15, green: 0.08, blue: 0.12)  // Deep purple-red dusk
        case .ocean: return Color(red: 0.05, green: 0.1, blue: 0.15)   // Deep ocean blue
        }
    }

    var wood: Color {
        switch self {
        case .viking: return Color(red: 0.35, green: 0.25, blue: 0.2)
        case .neon: return Color(red: 0.1, green: 0.1, blue: 0.2)
        case .metal: return Color(red: 0.55, green: 0.6, blue: 0.65)  // Brushed steel
        case .noir: return Color(red: 0.18, green: 0.18, blue: 0.18)
        case .sunset: return Color(red: 0.4, green: 0.22, blue: 0.25)  // Warm dusk wood
        case .ocean: return Color(red: 0.15, green: 0.25, blue: 0.35)  // Deep sea teal
        }
    }

    var stone: Color {
        switch self {
        case .viking: return Color(red: 0.25, green: 0.25, blue: 0.28)
        case .neon: return Color(red: 0.08, green: 0.08, blue: 0.15)
        case .metal: return Color(red: 0.35, green: 0.38, blue: 0.42)  // Polished chrome
        case .noir: return Color(red: 0.22, green: 0.22, blue: 0.22)
        case .sunset: return Color(red: 0.3, green: 0.18, blue: 0.22)  // Rose quartz
        case .ocean: return Color(red: 0.18, green: 0.28, blue: 0.32)  // Seafoam stone
        }
    }

    var primaryAccent: Color {
        switch self {
        case .viking: return Color(red: 0.85, green: 0.7, blue: 0.3)  // Gold
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)     // Cyan
        case .metal: return Color(red: 0.75, green: 0.85, blue: 0.95) // Chrome silver
        case .noir: return Color(red: 0.9, green: 0.9, blue: 0.9)     // White
        case .sunset: return Color(red: 1.0, green: 0.6, blue: 0.2)  // Sunset orange
        case .ocean: return Color(red: 0.2, green: 0.85, blue: 0.85)  // Aqua turquoise
        }
    }

    var secondaryAccent: Color {
        switch self {
        case .viking: return Color(red: 0.4, green: 0.7, blue: 0.85)  // Ice Blue
        case .neon: return Color(red: 1.0, green: 0.0, blue: 0.8)     // Magenta
        case .metal: return Color(red: 0.5, green: 0.75, blue: 0.9)   // Steel blue shine
        case .noir: return Color(red: 0.7, green: 0.7, blue: 0.7)     // Light Gray
        case .sunset: return Color(red: 1.0, green: 0.4, blue: 0.75)  // Pink-purple sky
        case .ocean: return Color(red: 1.0, green: 0.55, blue: 0.35)  // Coral reef orange
        }
    }

    // UI Element colors
    var buttonGray: Color {
        switch self {
        case .viking: return Color(red: 0.45, green: 0.45, blue: 0.5)
        case .neon: return Color(red: 0.2, green: 0.2, blue: 0.4)
        case .metal: return Color(red: 0.45, green: 0.5, blue: 0.55)   // Brushed aluminum
        case .noir: return Color(red: 0.35, green: 0.35, blue: 0.35)
        case .sunset: return Color(red: 0.5, green: 0.35, blue: 0.4)
        case .ocean: return Color(red: 0.3, green: 0.45, blue: 0.5)
        }
    }

    // Menu button colors - unique for each theme
    var playButtonColor: Color {
        switch self {
        case .viking: return Color(red: 0.3, green: 0.75, blue: 0.4)   // Emerald Green
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)      // Electric cyan
        case .metal: return Color(red: 0.75, green: 0.85, blue: 0.95)  // Chrome silver
        case .noir: return Color(red: 0.9, green: 0.9, blue: 0.9)      // White
        case .sunset: return Color(red: 1.0, green: 0.5, blue: 0.6)  // Coral pink
        case .ocean: return Color(red: 0.3, green: 0.9, blue: 0.7)   // Seafoam green
        }
    }

    var shopButtonColor: Color {
        switch self {
        case .viking: return Color(red: 0.85, green: 0.7, blue: 0.3)   // Gold
        case .neon: return Color(red: 1.0, green: 0.85, blue: 0.0)     // Electric yellow/gold
        case .metal: return Color(red: 1.0, green: 0.85, blue: 0.4)    // Polished gold
        case .noir: return Color(red: 0.5, green: 0.5, blue: 0.5)      // Medium Gray
        case .sunset: return Color(red: 1.0, green: 0.8, blue: 0.3)  // Golden hour
        case .ocean: return Color(red: 0.95, green: 0.9, blue: 0.65)  // Pearl/sand
        }
    }

    var leaderboardButtonColor: Color {
        switch self {
        case .viking: return Color(red: 0.4, green: 0.7, blue: 0.85)   // Ice Blue
        case .neon: return Color(red: 1.0, green: 0.0, blue: 0.8)      // Hot Magenta
        case .metal: return Color(red: 0.5, green: 0.75, blue: 0.9)    // Steel blue
        case .noir: return Color(red: 0.7, green: 0.7, blue: 0.7)      // Light Gray
        case .sunset: return Color(red: 0.75, green: 0.5, blue: 0.95)  // Lavender
        case .ocean: return Color(red: 0.15, green: 0.75, blue: 0.95)  // Deep cyan
        }
    }

    var settingsButtonColor: Color {
        switch self {
        case .viking: return Color(red: 0.5, green: 0.4, blue: 0.55)   // Purple stone
        case .neon: return Color(red: 0.6, green: 0.2, blue: 1.0)      // Electric purple
        case .metal: return Color(red: 0.55, green: 0.6, blue: 0.65)   // Brushed steel
        case .noir: return Color(red: 0.4, green: 0.4, blue: 0.4)      // Dark Gray
        case .sunset: return Color(red: 0.55, green: 0.3, blue: 0.6)  // Deep plum
        case .ocean: return Color(red: 0.2, green: 0.4, blue: 0.65)   // Navy blue
        }
    }

    // Button text colors - always white for main menu
    var playButtonTextColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)  // Always white
    }

    var shopButtonTextColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)  // Always white
    }

    var leaderboardButtonTextColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)  // Always white
    }

    var settingsButtonTextColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)  // Always white
    }

    var successColor: Color {
        switch self {
        case .viking: return Color(red: 0.3, green: 0.8, blue: 0.5)    // Forest Green
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.5)      // Electric Green
        case .metal: return Color(red: 0.4, green: 0.75, blue: 0.65)   // Chrome green
        case .noir: return Color(red: 0.6, green: 0.6, blue: 0.6)      // Gray
        case .sunset: return Color(red: 1.0, green: 0.7, blue: 0.4)  // Warm orange-gold
        case .ocean: return Color(red: 0.3, green: 0.85, blue: 0.7)  // Aqua green
        }
    }

    var dangerColor: Color {
        switch self {
        case .viking: return Color(red: 0.9, green: 0.25, blue: 0.25)  // Blood Red
        case .neon: return Color(red: 1.0, green: 0.1, blue: 0.4)      // Hot Pink
        case .metal: return Color(red: 0.85, green: 0.35, blue: 0.35)  // Metallic red
        case .noir: return Color(red: 0.5, green: 0.5, blue: 0.5)      // Dark Gray
        case .sunset: return Color(red: 1.0, green: 0.3, blue: 0.4)  // Sunset red
        case .ocean: return Color(red: 0.9, green: 0.4, blue: 0.35)  // Coral red
        }
    }

    // Text colors - HIGH CONTRAST
    var primaryText: Color {
        switch self {
        case .viking: return Color(red: 1.0, green: 1.0, blue: 1.0)     // Pure white
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.95)      // Bright Cyan
        case .metal: return Color(red: 1.0, green: 1.0, blue: 1.0)      // Pure white
        case .noir: return Color(red: 1.0, green: 1.0, blue: 1.0)       // Pure white
        case .sunset: return Color(red: 1.0, green: 1.0, blue: 1.0)     // Pure white
        case .ocean: return Color(red: 1.0, green: 1.0, blue: 1.0)      // Pure white
        }
    }

    var secondaryText: Color {
        switch self {
        case .viking: return Color(red: 0.85, green: 0.85, blue: 0.9)   // Light gray
        case .neon: return Color(red: 0.9, green: 0.6, blue: 0.95)      // Softer Magenta (reduced brightness for better readability)
        case .metal: return Color(red: 0.85, green: 0.9, blue: 0.95)    // Light steel
        case .noir: return Color(red: 0.85, green: 0.85, blue: 0.85)    // Light gray
        case .sunset: return Color(red: 1.0, green: 0.85, blue: 0.9)   // Warm light pink
        case .ocean: return Color(red: 0.8, green: 0.95, blue: 1.0)    // Light cyan
        }
    }

    var titleText: Color {
        switch self {
        case .viking: return Color(red: 1.0, green: 0.9, blue: 0.4)     // Bright gold
        case .neon: return Color(red: 0.0, green: 1.0, blue: 1.0)       // Electric Cyan
        case .metal: return Color(red: 1.0, green: 1.0, blue: 1.0)      // Pure white
        case .noir: return Color(red: 1.0, green: 1.0, blue: 1.0)       // Pure white
        case .sunset: return Color(red: 1.0, green: 0.85, blue: 0.3)     // Golden sunset
        case .ocean: return Color(red: 0.4, green: 0.95, blue: 1.0)      // Bright aqua
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
            case .i: return Color(red: 0.5, green: 0.85, blue: 1.0)   // Chrome cyan
            case .o: return Color(red: 1.0, green: 0.95, blue: 0.6)   // Polished platinum
            case .t: return Color(red: 0.75, green: 0.6, blue: 0.9)   // Brushed titanium purple
            case .s: return Color(red: 0.5, green: 0.9, blue: 0.7)    // Metallic mint
            case .z: return Color(red: 0.9, green: 0.5, blue: 0.5)    // Chrome red
            case .j: return Color(red: 0.5, green: 0.7, blue: 0.95)   // Steel blue
            case .l: return Color(red: 1.0, green: 0.75, blue: 0.5)   // Copper orange
            }
        case .noir:
            switch type {
            case .i: return Color(red: 1.0, green: 1.0, blue: 1.0)    // Pure White
            case .o: return Color(red: 0.78, green: 0.78, blue: 0.78) // Light Gray
            case .t: return Color(red: 0.85, green: 0.85, blue: 0.85) // Bright Gray
            case .s: return Color(red: 0.7, green: 0.7, blue: 0.7)    // Medium Gray
            case .z: return Color(red: 0.55, green: 0.55, blue: 0.55) // Slate Gray
            case .j: return Color(red: 0.4, green: 0.4, blue: 0.4)    // Charcoal
            case .l: return Color(red: 0.25, green: 0.25, blue: 0.25) // Deep Gray
            }
        case .sunset:
            switch type {
            case .i: return Color(red: 0.4, green: 0.7, blue: 1.0)    // Sky blue
            case .o: return Color(red: 1.0, green: 0.75, blue: 0.2)   // Warm golden
            case .t: return Color(red: 1.0, green: 0.4, blue: 0.7)    // Pink-purple
            case .s: return Color(red: 1.0, green: 0.9, blue: 0.3)    // Sunrise yellow
            case .z: return Color(red: 1.0, green: 0.35, blue: 0.3)   // Sunset red
            case .j: return Color(red: 0.65, green: 0.45, blue: 1.0)  // Lavender purple
            case .l: return Color(red: 1.0, green: 0.6, blue: 0.25)   // Sunset orange
            }
        case .ocean:
            switch type {
            case .i: return Color(red: 0.2, green: 0.8, blue: 1.0)    // Bright cyan
            case .o: return Color(red: 1.0, green: 0.85, blue: 0.5)   // Sand/pearl
            case .t: return Color(red: 0.3, green: 0.9, blue: 0.8)    // Turquoise
            case .s: return Color(red: 0.4, green: 1.0, blue: 0.6)    // Sea green
            case .z: return Color(red: 1.0, green: 0.5, blue: 0.35)   // Coral orange
            case .j: return Color(red: 0.2, green: 0.65, blue: 0.95)  // Deep sea blue
            case .l: return Color(red: 1.0, green: 0.75, blue: 0.3)   // Starfish yellow
            }
        }
    }

    // Board colors
    var boardBackground: Color {
        switch self {
        case .viking: return Color(red: 0.08, green: 0.08, blue: 0.12)
        case .neon: return Color(red: 0.02, green: 0.02, blue: 0.08)
        case .metal: return Color(red: 0.1, green: 0.12, blue: 0.14)   // Dark chrome
        case .noir: return Color(red: 0.05, green: 0.05, blue: 0.05)
        case .sunset: return Color(red: 0.1, green: 0.05, blue: 0.08)
        case .ocean: return Color(red: 0.03, green: 0.08, blue: 0.12)
        }
    }

    var cellBorder: Color {
        switch self {
        case .viking: return Color(white: 0.2, opacity: 0.3)
        case .neon: return Color(red: 0.0, green: 0.8, blue: 0.8, opacity: 0.2)
        case .metal: return Color(red: 0.6, green: 0.7, blue: 0.8, opacity: 0.4)  // Shiny chrome border
        case .noir: return Color(white: 0.3, opacity: 0.4)
        case .sunset: return Color(red: 1.0, green: 0.6, blue: 0.5, opacity: 0.25)
        case .ocean: return Color(red: 0.3, green: 0.8, blue: 0.9, opacity: 0.3)
        }
    }

    var emptyCell: Color {
        switch self {
        case .viking: return Color(white: 0.08, opacity: 0.2)
        case .neon: return Color(red: 0.02, green: 0.02, blue: 0.08, opacity: 0.2)
        case .metal: return Color(red: 0.18, green: 0.2, blue: 0.22, opacity: 0.2)
        case .noir: return Color(white: 0.06, opacity: 0.2)
        case .sunset: return Color(red: 0.15, green: 0.08, blue: 0.1, opacity: 0.2)
        case .ocean: return Color(red: 0.05, green: 0.1, blue: 0.15, opacity: 0.2)
        }
    }
}
