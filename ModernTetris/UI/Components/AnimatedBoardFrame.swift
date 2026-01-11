//
//  AnimatedBoardFrame.swift
//  SamoTetris
//
//  Created on 2026-01-11
//

import SwiftUI

/// Animated board frame overlay with pulsating and color-shifting effects
struct AnimatedBoardFrame: View {
    let frame: BoardFrame
    @State private var pulsePhase: Double = 0
    @State private var rainbowPhase: Double = 0
    @State private var neonPhase: Double = 0

    var body: some View {
        switch frame {
        case .neon:
            // Pulsating neon glow frame
            Rectangle()
                .strokeBorder(frame.frameColor, lineWidth: frame.lineWidth)
                .shadow(color: frame.glowColor.opacity(neonGlowIntensity), radius: 4 + neonGlowRadius)
                .shadow(color: frame.glowColor.opacity(neonGlowIntensity * 0.8), radius: 8 + neonGlowRadius * 1.5)
                .shadow(color: frame.glowColor.opacity(neonGlowIntensity * 0.6), radius: 16 + neonGlowRadius * 2)
                .shadow(color: frame.glowColor.opacity(neonGlowIntensity * 0.3), radius: 24 + neonGlowRadius * 3)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        neonPhase = 1.0
                    }
                }

        case .plasma:
            // Pulsating plasma frame
            Rectangle()
                .strokeBorder(frame.frameColor, lineWidth: frame.lineWidth)
                .shadow(color: frame.glowColor.opacity(pulseIntensity), radius: 6 + pulseOffset)
                .shadow(color: frame.glowColor.opacity(pulseIntensity * 0.6), radius: 12 + pulseOffset * 2)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        pulsePhase = 1.0
                    }
                }

        case .rainbow:
            // Rainbow spectrum shifting frame
            Rectangle()
                .strokeBorder(
                    LinearGradient(
                        colors: rainbowColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: frame.lineWidth
                )
                .shadow(color: currentRainbowGlow, radius: 8)
                .onAppear {
                    withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                        rainbowPhase = 1.0
                    }
                }

        default:
            // Static frame (classic, golden, wooden, crystal)
            Rectangle()
                .strokeBorder(frame.frameColor, lineWidth: frame.lineWidth)
                .shadow(color: frame.glowColor.opacity(0.5), radius: 6)
        }
    }

    // MARK: - Neon Animation

    private var neonGlowIntensity: Double {
        0.5 + (neonPhase * 0.4)  // Pulsates from 0.5 to 0.9 opacity for strong glow
    }

    private var neonGlowRadius: Double {
        neonPhase * 10  // Glow radius varies by 10 points for vibrant neon effect
    }

    // MARK: - Plasma Animation

    private var pulseIntensity: Double {
        0.3 + (pulsePhase * 0.5)  // Pulsates from 0.3 to 0.8 opacity
    }

    private var pulseOffset: Double {
        pulsePhase * 8  // Glow radius varies by 8 points
    }

    // MARK: - Rainbow Animation

    private var rainbowColors: [Color] {
        let colors: [Color] = [
            Color(red: 1.0, green: 0.0, blue: 0.0),    // Red
            Color(red: 1.0, green: 0.5, blue: 0.0),    // Orange
            Color(red: 1.0, green: 1.0, blue: 0.0),    // Yellow
            Color(red: 0.0, green: 1.0, blue: 0.0),    // Green
            Color(red: 0.0, green: 0.5, blue: 1.0),    // Blue
            Color(red: 0.5, green: 0.0, blue: 1.0),    // Indigo
            Color(red: 1.0, green: 0.0, blue: 1.0),    // Violet
        ]

        // Rotate colors based on animation phase
        let rotation = Int(rainbowPhase * 7)
        return Array(colors.dropFirst(rotation)) + Array(colors.prefix(rotation))
    }

    private var currentRainbowGlow: Color {
        // Glow color cycles through rainbow
        let hue = rainbowPhase
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
}
