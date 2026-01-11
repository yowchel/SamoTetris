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
    case backgroundAnimation
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

    // For background animations
    var backgroundAnimation: BackgroundAnimation?
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

    // Custom particle effect preview icon
    @ViewBuilder
    var iconView: some View {
        ZStack {
            // Dark background
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black.opacity(0.7))
                .frame(width: 32, height: 32)

            // Effect-specific icon with color
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(effectColor)
                .shadow(color: effectColor.opacity(0.7), radius: 4)
        }
    }

    // Color representing each effect
    var effectColor: Color {
        switch self {
        case .stars: return Color.yellow
        case .confetti: return Color(red: 1.0, green: 0.4, blue: 0.8)  // Pink
        case .lightning: return Color.cyan
        case .fire: return Color.orange
        case .hearts: return Color.red
        case .sparkles: return Color.white
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
    case plasma = "Plasma"
    case rainbow = "Rainbow"

    var icon: String {
        // Icon is now used for fallback only, main display uses iconView
        return "square"
    }

    // Custom frame preview icon
    @ViewBuilder
    var iconView: some View {
        switch self {
        case .rainbow:
            // Rainbow gradient frame
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 32, height: 32)

                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.red,
                                Color.orange,
                                Color.yellow,
                                Color.green,
                                Color.blue,
                                Color.purple
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2.5
                    )
                    .frame(width: 32, height: 32)
                    .shadow(color: Color.purple.opacity(0.6), radius: 3)
            }
        default:
            // Static frame preview (classic, golden, neon, wooden, crystal, plasma)
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 32, height: 32)

                // Frame border
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(frameColor, lineWidth: lineWidth / 1.5)
                    .frame(width: 32, height: 32)
                    .shadow(color: glowColor.opacity(0.6), radius: 3)
            }
        }
    }

    var price: Int {
        switch self {
        case .classic: return 0      // Free default frame
        case .golden: return 400
        case .neon: return 450
        case .wooden: return 300
        case .crystal: return 500
        case .plasma: return 550
        case .rainbow: return 600
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
        case .plasma: return Color(red: 0.8, green: 0.2, blue: 1.0)   // Electric purple
        case .rainbow: return Color(red: 1.0, green: 0.4, blue: 0.6)  // Will animate through spectrum
        }
    }

    var glowColor: Color {
        switch self {
        case .classic: return Color(red: 0.5, green: 0.5, blue: 0.5)  // Medium gray
        case .golden: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .neon: return Color(red: 0.0, green: 1.0, blue: 0.8)
        case .wooden: return Color(red: 0.4, green: 0.25, blue: 0.1)
        case .crystal: return Color(red: 0.5, green: 0.8, blue: 1.0)
        case .plasma: return Color(red: 0.6, green: 0.3, blue: 1.0)   // Purple glow
        case .rainbow: return Color(red: 1.0, green: 0.6, blue: 0.3)  // Warm glow
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .classic: return 2
        case .golden: return 4
        case .neon: return 3
        case .wooden: return 5
        case .crystal: return 3
        case .plasma: return 4
        case .rainbow: return 4
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
        case .sunset: return 650  // Premium
        case .ocean: return 600   // Premium
        }
    }

    var icon: String {
        // Fallback icon
        return "square.fill"
    }

    // Custom theme preview icon - circular color palette with 4 segments (main colors only)
    @ViewBuilder
    var iconView: some View {
        ZStack {
            Circle()
                .frame(width: 44, height: 44)
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            // Top-left quadrant - Primary Accent
                            Path { path in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                path.move(to: center)
                                path.addArc(center: center,
                                           radius: geometry.size.width / 2,
                                           startAngle: .degrees(135),
                                           endAngle: .degrees(225),
                                           clockwise: false)
                            }
                            .fill(self.primaryAccent)

                            // Top-right quadrant - Secondary Accent
                            Path { path in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                path.move(to: center)
                                path.addArc(center: center,
                                           radius: geometry.size.width / 2,
                                           startAngle: .degrees(225),
                                           endAngle: .degrees(315),
                                           clockwise: false)
                            }
                            .fill(self.secondaryAccent)

                            // Bottom-right quadrant - Wood/Stone
                            Path { path in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                path.move(to: center)
                                path.addArc(center: center,
                                           radius: geometry.size.width / 2,
                                           startAngle: .degrees(315),
                                           endAngle: .degrees(45),
                                           clockwise: false)
                            }
                            .fill(self.wood)

                            // Bottom-left quadrant - Stone
                            Path { path in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                path.move(to: center)
                                path.addArc(center: center,
                                           radius: geometry.size.width / 2,
                                           startAngle: .degrees(45),
                                           endAngle: .degrees(135),
                                           clockwise: false)
                            }
                            .fill(self.stone)
                        }
                    }
                )
                .clipShape(Circle())
        }
    }
}

/// Background animation styles
enum BackgroundAnimation: String, CaseIterable {
    case tetromino = "Tetromino"  // Default - falling tetromino pieces
    case bubbles = "Bubbles"
    case particles = "Particles"

    var icon: String {
        switch self {
        case .tetromino: return "square.grid.3x2.fill"
        case .bubbles: return "circle.hexagongrid.fill"
        case .particles: return "sparkles"
        }
    }

    // Custom background animation preview icon
    @ViewBuilder
    var iconView: some View {
        switch self {
        case .tetromino:
            // Falling tetromino blocks
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.1, blue: 0.15),
                                Color(red: 0.08, green: 0.05, blue: 0.12)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 32, height: 32)

                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.purple)
                            .frame(width: 6, height: 6)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.cyan)
                            .frame(width: 6, height: 6)
                    }
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.orange)
                            .frame(width: 6, height: 6)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.yellow)
                            .frame(width: 6, height: 6)
                    }
                }
            }

        case .bubbles:
            // Floating bubbles
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.1, blue: 0.15),
                                Color(red: 0.08, green: 0.05, blue: 0.12)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 32, height: 32)

                VStack(spacing: 3) {
                    HStack(spacing: 3) {
                        Circle()
                            .strokeBorder(Color.cyan.opacity(0.6), lineWidth: 1)
                            .frame(width: 8, height: 8)
                        Circle()
                            .strokeBorder(Color.purple.opacity(0.6), lineWidth: 1)
                            .frame(width: 6, height: 6)
                    }
                    HStack(spacing: 3) {
                        Circle()
                            .strokeBorder(Color.pink.opacity(0.6), lineWidth: 1)
                            .frame(width: 6, height: 6)
                        Circle()
                            .strokeBorder(Color.blue.opacity(0.6), lineWidth: 1)
                            .frame(width: 7, height: 7)
                    }
                }
            }

        case .particles:
            // Sparkling particles
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.1, blue: 0.15),
                                Color(red: 0.08, green: 0.05, blue: 0.12)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 32, height: 32)

                // Small colored dots scattered
                VStack(spacing: 4) {
                    HStack(spacing: 5) {
                        Circle().fill(Color.yellow).frame(width: 3, height: 3)
                        Circle().fill(Color.cyan).frame(width: 2, height: 2)
                        Circle().fill(Color.pink).frame(width: 3, height: 3)
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color.white).frame(width: 2, height: 2)
                        Circle().fill(Color.purple).frame(width: 3, height: 3)
                        Circle().fill(Color.blue).frame(width: 2, height: 2)
                    }
                    HStack(spacing: 5) {
                        Circle().fill(Color.green).frame(width: 2, height: 2)
                        Circle().fill(Color.orange).frame(width: 3, height: 3)
                        Circle().fill(Color.pink).frame(width: 2, height: 2)
                    }
                }
            }
        }
    }

    var price: Int {
        switch self {
        case .tetromino: return 0  // Free default
        case .bubbles: return 400
        case .particles: return 450
        }
    }

    var isFree: Bool {
        return self == .tetromino
    }
}
