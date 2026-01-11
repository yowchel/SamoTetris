//
//  ParticlesBackground.swift
//  SamoTetris
//
//  Created on 2026-01-10
//

import SwiftUI

/// Single particle for background animation
struct ParticleView: View {
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let delay: Double
    let fadeDuration: Double
    let moveDuration: Double
    let color: Color

    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: 1.5)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .position(position)
            .onAppear {
                position = CGPoint(x: startX, y: startY)

                // Delayed start for sequential fade-in effect
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    // Smooth fade in
                    withAnimation(.easeIn(duration: fadeDuration)) {
                        opacity = 0.85
                    }

                    // Gentle movement
                    withAnimation(.linear(duration: moveDuration).repeatForever(autoreverses: true)) {
                        position = CGPoint(x: endX, y: endY)
                    }

                    // Slow pulsing glow
                    withAnimation(.easeInOut(duration: fadeDuration * 1.5).repeatForever(autoreverses: true)) {
                        opacity = 0.3
                    }

                    // Gentle rotation
                    withAnimation(.linear(duration: moveDuration).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            }
    }
}

/// Background view with multiple floating particles
struct ParticlesBackground: View {
    @State private var particles: [ParticleData] = []
    var isGameScreen: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(
                        size: particle.size,
                        startX: particle.startX,
                        startY: particle.startY,
                        endX: particle.endX,
                        endY: particle.endY,
                        delay: particle.delay,
                        fadeDuration: particle.fadeDuration,
                        moveDuration: particle.moveDuration,
                        color: particle.color
                    )
                }
            }
            .onAppear {
                generateParticles(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
            }
        }
    }

    private func generateParticles(screenWidth: CGFloat, screenHeight: CGFloat) {
        // More particles for rich starfield effect
        let count = isGameScreen ? Int.random(in: 70...90) : Int.random(in: 60...80)

        // Color palette for particles (soft, pastel colors)
        let colorPalette: [Color] = [
            Color(red: 1.0, green: 0.8, blue: 0.4),   // Warm gold
            Color(red: 0.6, green: 0.8, blue: 1.0),   // Soft blue
            Color(red: 1.0, green: 0.6, blue: 0.8),   // Soft pink
            Color(red: 0.7, green: 1.0, blue: 0.8),   // Soft green
            Color(red: 0.9, green: 0.7, blue: 1.0),   // Soft purple
            Color.white                                // White sparkles
        ]

        for i in 0..<count {
            // Small particle sizes
            let size = isGameScreen ? CGFloat.random(in: 2...7) : CGFloat.random(in: 2...6)

            // Random position
            let startX = CGFloat.random(in: 0...screenWidth)
            let startY = CGFloat.random(in: 0...screenHeight)

            // More visible drift
            let endX = startX + CGFloat.random(in: -120...120)
            let endY = startY + CGFloat.random(in: -140...140)

            // Sequential delay for smooth fade-in wave effect
            let delay = Double(i) * 0.08  // 80ms between each particle

            // Fade duration (how long to fade in/out)
            let fadeDuration = Double.random(in: 2.0...3.5)

            // Movement duration (faster for more visible movement)
            let moveDuration = Double.random(in: 4...7)

            // Random color from palette
            let color = colorPalette.randomElement() ?? .white

            let particle = ParticleData(
                size: size,
                startX: startX,
                startY: startY,
                endX: endX,
                endY: endY,
                delay: delay,
                fadeDuration: fadeDuration,
                moveDuration: moveDuration,
                color: color
            )

            particles.append(particle)
        }
    }
}

/// Data model for a particle
struct ParticleData: Identifiable {
    let id = UUID()
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let delay: Double
    let fadeDuration: Double
    let moveDuration: Double
    let color: Color
}
