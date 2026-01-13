//
//  GlassmorphicTitle.swift
//  SamoTetris
//
//  Created on 2026-01-12
//

import SwiftUI

/// Glassmorphic title with iOS 18+ style glass effect and glow
struct GlassmorphicTitle: View {
    let text: String
    @State private var glowOffset: CGSize = .zero
    @State private var rotation: Double = 0
    @ObservedObject private var themeManager = ThemeManager.shared

    // Calculate current glow position
    private var glowX: CGFloat {
        cos(rotation) * 120
    }

    private var glowY: CGFloat {
        sin(rotation) * 5
    }

    // Break down complex gradients into computed properties
    private var glowGradient: RadialGradient {
        RadialGradient(
            colors: [
                themeManager.currentTheme.primaryAccent.opacity(0.5),
                themeManager.currentTheme.secondaryAccent.opacity(0.3),
                Color.clear
            ],
            center: .center,
            startRadius: 10,
            endRadius: 80
        )
    }

    private var textGradient: LinearGradient {
        // Dynamic gradient based on theme colors - more saturated and vibrant
        let baseColor = Color.white
        let midColor = themeManager.currentTheme.titleTextColor
        let bottomColor = themeManager.currentTheme.titleGlowColor

        return LinearGradient(
            colors: [
                mixColors(baseColor, midColor, ratio: 0.2).opacity(0.98),  // More color at top
                mixColors(baseColor, midColor, ratio: 0.6).opacity(0.92),  // Stronger mid color
                mixColors(midColor, bottomColor, ratio: 0.7).opacity(0.85) // More vibrant bottom
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // Helper function to mix two colors
    private func mixColors(_ color1: Color, _ color2: Color, ratio: Double) -> Color {
        let c1 = color1.components
        let c2 = color2.components

        return Color(
            red: c1.red * (1 - ratio) + c2.red * ratio,
            green: c1.green * (1 - ratio) + c2.green * ratio,
            blue: c1.blue * (1 - ratio) + c2.blue * ratio
        )
    }

    // Dynamic highlight color based on glow position with smooth interpolation
    private var currentHighlightColor: Color {
        // Normalize glowX position from -120...120 to 0...1
        // When glowX = -120 (left), interpolation = 0 (full titleTextColor)
        // When glowX = 120 (right), interpolation = 1 (full titleGlowColor)
        let interpolation = (glowX + 120) / 240

        // Get color components
        let leftColor = themeManager.currentTheme.titleTextColor
        let rightColor = themeManager.currentTheme.titleGlowColor

        // Smooth color interpolation
        return Color(
            red: Double(interpolation) * rightColor.components.red + Double(1 - interpolation) * leftColor.components.red,
            green: Double(interpolation) * rightColor.components.green + Double(1 - interpolation) * leftColor.components.green,
            blue: Double(interpolation) * rightColor.components.blue + Double(1 - interpolation) * leftColor.components.blue
        )
    }

    private var glowLayers: some View {
        // Wide oval-shaped glowing orb that moves around the text
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        currentHighlightColor.opacity(0.7),
                        currentHighlightColor.opacity(0.5),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 8,
                    endRadius: 60
                )
            )
            .frame(width: 140, height: 80)
            .blur(radius: 30)
            .offset(x: glowX, y: glowY)
    }

    private var mainText: some View {
        Text(text)
            .font(.system(size: 56, weight: .bold))
            .foregroundStyle(textGradient)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }

    var body: some View {
        ZStack {
            glowLayers
            mainText

            // Dynamic highlight layer that follows the glow - color changes based on position
            Text(text)
                .font(.system(size: 56, weight: .bold))
                .foregroundStyle(currentHighlightColor)
                .brightness(0.3)
                .saturation(2.0)
                .mask(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(1.0),
                            Color.white.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 60
                    )
                    .offset(x: glowX, y: glowY)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .onAppear {
            // Start continuous smooth rotation animation using Timer
            Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                rotation += 0.01  // Slower, smoother rotation
                if rotation >= .pi * 2 {
                    rotation -= .pi * 2
                }
            }
        }
    }
}

#Preview {
    ZStack {
        // Uses current theme colors
        ThemeManager.shared.currentTheme.background
            .ignoresSafeArea()

        GlassmorphicTitle(text: "SAMO TETRIS")
    }
}

// Extension to extract RGB components from Color
extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }

        return (Double(r), Double(g), Double(b), Double(o))
    }
}
