//
//  BubblesBackground.swift
//  SamoTetris
//
//  Created on 2026-01-10
//

import SwiftUI

/// Single bubble for background animation
struct Bubble: View {
    let size: CGFloat
    let startX: CGFloat
    let delay: Double
    let duration: Double
    let xOffset: CGFloat

    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 0.6
    @State private var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .opacity(opacity)
                .scaleEffect(scale)
                .offset(x: startX + xOffset, y: yOffset)
                .onAppear {
                    let screenHeight = geometry.size.height

                    // Start from bottom of screen
                    yOffset = screenHeight + size

                    // Delayed start for staggered effect
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        // Float up animation - from bottom to top, then restart
                        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                            yOffset = -size - 100
                        }

                        // Subtle scale pulsing
                        withAnimation(.easeInOut(duration: duration / 3).repeatForever(autoreverses: true)) {
                            scale = 1.15
                        }

                        // Gentle fade in/out
                        withAnimation(.easeInOut(duration: duration / 2).repeatForever(autoreverses: true)) {
                            opacity = 0.35
                        }
                    }
                }
        }
    }
}

/// Background view with multiple floating bubbles
struct BubblesBackground: View {
    @State private var bubbles: [BubbleData] = []
    var isGameScreen: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    Bubble(
                        size: bubble.size,
                        startX: bubble.startX,
                        delay: bubble.delay,
                        duration: bubble.duration,
                        xOffset: bubble.xOffset
                    )
                }
            }
            .onAppear {
                generateBubbles(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
            }
        }
    }

    private func generateBubbles(screenWidth: CGFloat, screenHeight: CGFloat) {
        // More bubbles for continuous smooth flow
        let count = isGameScreen ? Int.random(in: 55...70) : Int.random(in: 45...60)

        for i in 0..<count {
            // Varied bubble sizes
            let size = isGameScreen ? CGFloat.random(in: 25...75) : CGFloat.random(in: 20...65)
            let startX = CGFloat.random(in: -50...(screenWidth + 50))

            // Stagger delays evenly so bubbles appear one by one
            let delay = Double(i) * (0.15)  // 150ms between each bubble start

            // Slower, more consistent duration for smooth motion
            let duration = isGameScreen ? Double.random(in: 18...24) : Double.random(in: 15...22)

            // Gentle horizontal drift
            let xOffset = CGFloat.random(in: -25...25)

            let bubble = BubbleData(
                size: size,
                startX: startX,
                delay: delay,
                duration: duration,
                xOffset: xOffset
            )

            bubbles.append(bubble)
        }
    }
}

/// Data model for a bubble
struct BubbleData: Identifiable {
    let id = UUID()
    let size: CGFloat
    let startX: CGFloat
    let delay: Double
    let duration: Double
    let xOffset: CGFloat
}
