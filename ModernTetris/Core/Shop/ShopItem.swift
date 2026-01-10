//
//  ShopItem.swift
//  SamoTetris
//
//  Created on 2026-01-04
//

import SwiftUI

/// Types of items available in the shop
enum ShopItemType {
    case theme
    case particleEffect
    case boardFrame
    case boost
    case avatar
}

/// Shop item model
struct ShopItem: Identifiable, Hashable {
    let id: String
    let type: ShopItemType
    let name: String
    let description: String
    let price: Int
    let icon: String  // SF Symbol name
    let isPremium: Bool

    // For themes
    var theme: GameTheme?

    // For particle effects
    var particleEffect: ParticleEffect?

    // For board frames
    var frameStyle: BoardFrame?
}

/// Available particle effects for line clearing
enum ParticleEffect: String, CaseIterable {
    case stars = "Stars"
    case confetti = "Confetti"
    case lightning = "Lightning"
    case fire = "Fire"
    case hearts = "Hearts"
    case sparkles = "Sparkles"

    var icon: String {
        switch self {
        case .stars: return "star.fill"
        case .confetti: return "sparkles"
        case .lightning: return "bolt.fill"
        case .fire: return "flame.fill"
        case .hearts: return "heart.fill"
        case .sparkles: return "sparkle"
        }
    }

    var price: Int {
        switch self {
        case .stars: return 200
        case .confetti: return 200
        case .lightning: return 300
        case .fire: return 350
        case .hearts: return 250
        case .sparkles: return 300
        }
    }
}

/// Board frame styles
enum BoardFrame: String, CaseIterable {
    case classic = "Classic"
    case golden = "Golden"
    case neon = "Neon"
    case wooden = "Wooden"
    case crystal = "Crystal"

    var icon: String {
        switch self {
        case .classic: return "square"
        case .golden: return "square.dashed"
        case .neon: return "rectangle.dashed"
        case .wooden: return "square.grid.3x3"
        case .crystal: return "diamond"
        }
    }

    var price: Int {
        switch self {
        case .classic: return 0      // Free default frame
        case .golden: return 400
        case .neon: return 450
        case .wooden: return 300
        case .crystal: return 500
        }
    }

    var isFree: Bool {
        return self == .classic
    }

    var frameColor: Color {
        switch self {
        case .classic: return Color(red: 0.7, green: 0.7, blue: 0.7)  // Light gray
        case .golden: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)
        case .wooden: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .crystal: return Color(red: 0.7, green: 0.9, blue: 1.0)
        }
    }

    var glowColor: Color {
        switch self {
        case .classic: return Color(red: 0.5, green: 0.5, blue: 0.5)  // Medium gray
        case .golden: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)
        case .wooden: return Color(red: 0.4, green: 0.25, blue: 0.1)
        case .crystal: return Color(red: 0.5, green: 0.8, blue: 1.0)
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .classic: return 2
        case .golden: return 4
        case .neon: return 3
        case .wooden: return 5
        case .crystal: return 3
        }
    }
}

/// Theme pricing and availability
extension GameTheme {
    var isFree: Bool {
        return self == .noir
    }

    var price: Int {
        switch self {
        case .noir: return 0      // Free default theme
        case .viking: return 500  // Premium
        case .neon: return 600    // Premium
        case .metal: return 550   // Premium
        }
    }

    var icon: String {
        switch self {
        case .viking: return "shield.fill"
        case .neon: return "bolt.fill"
        case .metal: return "hammer.fill"
        case .noir: return "film.fill"
        }
    }
}
