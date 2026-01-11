//
//  ParticleEffectView.swift
//  SamoTetris
//
//  Created on 2026-01-05
//

import SwiftUI

/// Enhanced particle effect view with improved animations
struct ParticleEffectView: View {
    let effect: ParticleEffect
    let clearingLines: Set<Int>
    let blockSize: CGFloat
    let boardWidth: Int

    @State private var particles: [Particle] = []
    @State private var previousClearingLines: Set<Int> = []
    @ObservedObject private var shopManager = ShopManager.shared

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                particleView(particle)
            }
        }
        .onAppear {
            // Мгновенная генерация при появлении новых линий
            if !clearingLines.isEmpty && clearingLines != previousClearingLines {
                generateParticles(for: clearingLines)
                previousClearingLines = clearingLines
            }
        }
        .onChange(of: clearingLines) { newValue in
            // Мгновенная генерация без задержки
            if !newValue.isEmpty && newValue != previousClearingLines {
                generateParticles(for: newValue)
                previousClearingLines = newValue
            } else if newValue.isEmpty {
                previousClearingLines = []
            }
        }
    }

    @ViewBuilder
    private func particleView(_ particle: Particle) -> some View {
        Group {
            switch effect {
            case .stars:
                // Enhanced stars with glow
                ZStack {
                    ForEach(0..<10, id: \.self) { i in
                        Rectangle()
                            .fill(particle.color)
                            .frame(width: particle.size * 0.15, height: particle.size * 1.2)
                            .rotationEffect(.degrees(Double(i) * 36))
                    }
                }
                .shadow(color: particle.color, radius: 15, x: 0, y: 0)
                .rotationEffect(.degrees(particle.rotation))

            case .confetti:
                // 3D rotating confetti
                RoundedRectangle(cornerRadius: particle.size * 0.2)
                    .fill(
                        LinearGradient(
                            colors: [particle.color, particle.color.opacity(0.7), particle.color],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: particle.size * 0.7, height: particle.size * 1.4)
                    .rotation3DEffect(
                        .degrees(particle.rotation),
                        axis: (x: 1, y: 1, z: 0.3)
                    )
                    .shadow(color: particle.color.opacity(0.5), radius: 8, x: 0, y: 4)

            case .lightning:
                // Electric lightning bolts
                ZStack {
                    Path { path in
                        let w = particle.size
                        let h = particle.size * 2.5
                        path.move(to: CGPoint(x: w * 0.5, y: 0))
                        path.addLine(to: CGPoint(x: w * 0.2, y: h * 0.25))
                        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.3))
                        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.6))
                        path.addLine(to: CGPoint(x: w * 0.6, y: h * 0.65))
                        path.addLine(to: CGPoint(x: w * 0.3, y: h))
                        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.7))
                        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.5))
                        path.addLine(to: CGPoint(x: w * 0.6, y: h * 0.2))
                        path.closeSubpath()
                    }
                    .fill(particle.color)
                    .shadow(color: particle.color, radius: 20, x: 0, y: 0)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                }
                .frame(width: particle.size, height: particle.size * 2.5)
                .rotationEffect(.degrees(particle.rotation))

            case .fire:
                // Animated flame with multiple layers
                ZStack {
                    ForEach(0..<3, id: \.self) { layer in
                        Path { path in
                            let w = particle.size * (1.0 - Double(layer) * 0.15)
                            let h = particle.size * 1.8 * (1.0 - Double(layer) * 0.15)
                            path.move(to: CGPoint(x: w * 0.5, y: h))
                            path.addQuadCurve(
                                to: CGPoint(x: w * 0.25, y: h * 0.4),
                                control: CGPoint(x: w * 0.15, y: h * 0.75)
                            )
                            path.addQuadCurve(
                                to: CGPoint(x: w * 0.5, y: 0),
                                control: CGPoint(x: w * 0.25, y: h * 0.15)
                            )
                            path.addQuadCurve(
                                to: CGPoint(x: w * 0.75, y: h * 0.4),
                                control: CGPoint(x: w * 0.75, y: h * 0.15)
                            )
                            path.addQuadCurve(
                                to: CGPoint(x: w * 0.5, y: h),
                                control: CGPoint(x: w * 0.85, y: h * 0.75)
                            )
                        }
                        .fill(
                            RadialGradient(
                                colors: layer == 0 ? [.yellow, .orange, particle.color] :
                                        layer == 1 ? [.white, .yellow, .orange] :
                                        [.white, .white.opacity(0.8), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                        .offset(y: CGFloat(layer) * particle.size * 0.1)
                    }
                }
                .frame(width: particle.size, height: particle.size * 1.8)
                .shadow(color: particle.color, radius: 25, x: 0, y: 0)

            case .hearts:
                // Pulsing hearts
                Path { path in
                    let w = particle.size
                    let h = particle.size
                    path.move(to: CGPoint(x: w * 0.5, y: h * 0.35))
                    path.addCurve(
                        to: CGPoint(x: 0, y: h * 0.25),
                        control1: CGPoint(x: w * 0.5, y: h * 0.05),
                        control2: CGPoint(x: 0, y: 0)
                    )
                    path.addCurve(
                        to: CGPoint(x: w * 0.5, y: h),
                        control1: CGPoint(x: 0, y: h * 0.6),
                        control2: CGPoint(x: w * 0.5, y: h * 0.8)
                    )
                    path.addCurve(
                        to: CGPoint(x: w, y: h * 0.25),
                        control1: CGPoint(x: w * 0.5, y: h * 0.8),
                        control2: CGPoint(x: w, y: h * 0.6)
                    )
                    path.addCurve(
                        to: CGPoint(x: w * 0.5, y: h * 0.35),
                        control1: CGPoint(x: w, y: 0),
                        control2: CGPoint(x: w * 0.5, y: h * 0.05)
                    )
                }
                .fill(
                    RadialGradient(
                        colors: [particle.color.opacity(0.9), particle.color],
                        center: .center,
                        startRadius: 0,
                        endRadius: particle.size * 0.6
                    )
                )
                .frame(width: particle.size, height: particle.size)
                .rotationEffect(.degrees(particle.rotation))
                .shadow(color: particle.color.opacity(0.8), radius: 12, x: 0, y: 0)

            case .sparkles:
                // Multi-layer sparkles
                ZStack {
                    // Main cross beams
                    ForEach(0..<2, id: \.self) { beam in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        particle.color.opacity(0),
                                        .white,
                                        particle.color,
                                        .white,
                                        particle.color.opacity(0)
                                    ],
                                    startPoint: beam == 0 ? .leading : .top,
                                    endPoint: beam == 0 ? .trailing : .bottom
                                )
                            )
                            .frame(
                                width: beam == 0 ? particle.size * 2 : particle.size * 0.3,
                                height: beam == 0 ? particle.size * 0.3 : particle.size * 2
                            )
                    }

                    // Diagonal beams
                    ForEach(0..<2, id: \.self) { diag in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [particle.color.opacity(0), particle.color, particle.color.opacity(0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: particle.size * 1.5, height: particle.size * 0.2)
                            .rotationEffect(.degrees(diag == 0 ? 45 : -45))
                    }

                    // Center glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white, particle.color, particle.color.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size * 0.5
                            )
                        )
                        .frame(width: particle.size * 0.6, height: particle.size * 0.6)
                }
                .shadow(color: .white, radius: 15, x: 0, y: 0)
                .shadow(color: particle.color, radius: 20, x: 0, y: 0)
                .rotationEffect(.degrees(particle.rotation))
            }
        }
        .opacity(particle.opacity)
        .position(particle.position)
        .scaleEffect(particle.scale)
        .blur(radius: particle.blur)
    }

    private func generateParticles(for lines: Set<Int>) {
        // Очищаем только старые частицы, не текущие
        particles.removeAll()

        let colors = effect.colors(for: shopManager.currentTheme)
        let particleCount = effect.particleCount

        for row in lines {
            // Y позиция с учетом padding = 6
            // row * blockSize дает верхнюю часть блока
            // + blockSize/2 центрирует по вертикали блока
            let yPosition = 6 + (CGFloat(row) * blockSize) + (blockSize / 2)

            for _ in 0..<particleCount {
                // X позиция: от 6 (padding) до 6 + ширина доски
                // Равномерно распределяем по всей ширине линии
                let xPosition = 6 + CGFloat.random(in: 0...(CGFloat(boardWidth) * blockSize))
                let initialPosition = CGPoint(x: xPosition, y: yPosition)

                let color = colors.randomElement() ?? .white
                let size = effect.particleSize
                let velocity = effect.velocity
                let lifespan = effect.lifespan

                let particle = Particle(
                    position: initialPosition,
                    velocity: velocity,
                    color: color,
                    size: size,
                    rotation: 0,
                    opacity: 1.0,
                    scale: 1.0,
                    blur: 0,
                    lifespan: lifespan,
                    effect: effect
                )

                particles.append(particle)
            }
        }

        // Запускаем анимацию сразу же
        animateParticles()
    }

    private func animateParticles() {
        // Анимируем все частицы одновременно
        for index in particles.indices {
            let particle = particles[index]
            let duration = particle.lifespan

            // Мгновенный старт анимации без задержки
            withAnimation(.easeOut(duration: duration)) {
                particles[index].position = CGPoint(
                    x: particle.position.x + particle.velocity.dx,
                    y: particle.position.y + particle.velocity.dy
                )
                particles[index].opacity = 0
                particles[index].scale = 0.3
                particles[index].blur = 2

                // Rotation в той же анимации
                switch particle.effect {
                case .confetti:
                    particles[index].rotation = Double.random(in: 360...540)
                case .stars:
                    particles[index].rotation = Double.random(in: -180...180)
                case .hearts:
                    particles[index].rotation = Double.random(in: -20...20)
                case .sparkles:
                    particles[index].rotation = 360
                case .lightning:
                    particles[index].rotation = Double.random(in: -60...60)
                case .fire:
                    particles[index].scale = 0.5
                }
            }
        }

        // Удаляем частицы после завершения анимации
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            particles.removeAll()
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let velocity: CGVector
    let color: Color
    let size: CGFloat
    var rotation: Double
    var opacity: Double
    var scale: Double
    var blur: CGFloat
    let lifespan: Double
    let effect: ParticleEffect
}

extension ParticleEffect {
    var particleCount: Int {
        // ОПТИМИЗИРОВАНО: меньше частиц = нет фризов
        switch self {
        case .stars: return 8
        case .confetti: return 10
        case .lightning: return 5
        case .fire: return 7
        case .hearts: return 6
        case .sparkles: return 10
        }
    }

    var particleSize: CGFloat {
        switch self {
        case .stars: return 22
        case .confetti: return 12
        case .lightning: return 14
        case .fire: return 20
        case .hearts: return 24
        case .sparkles: return 20
        }
    }

    var velocity: CGVector {
        switch self {
        case .stars:
            return CGVector(
                dx: CGFloat.random(in: -120...120),
                dy: CGFloat.random(in: -180...(-100))
            )
        case .confetti:
            return CGVector(
                dx: CGFloat.random(in: -100...100),
                dy: CGFloat.random(in: -200...(-120))
            )
        case .lightning:
            return CGVector(
                dx: CGFloat.random(in: -60...60),
                dy: CGFloat.random(in: -250...(-180))
            )
        case .fire:
            return CGVector(
                dx: CGFloat.random(in: -50...50),
                dy: CGFloat.random(in: -160...(-110))
            )
        case .hearts:
            return CGVector(
                dx: CGFloat.random(in: -80...80),
                dy: CGFloat.random(in: -140...(-80))
            )
        case .sparkles:
            return CGVector(
                dx: CGFloat.random(in: -140...140),
                dy: CGFloat.random(in: -140...(-70))
            )
        }
    }

    var lifespan: Double {
        switch self {
        case .stars: return 1.2
        case .confetti: return 1.5
        case .lightning: return 0.8
        case .fire: return 1.3
        case .hearts: return 1.6
        case .sparkles: return 1.0
        }
    }

    func colors(for theme: GameTheme) -> [Color] {
        switch self {
        case .stars:
            return [.yellow, .white, Color(red: 1.0, green: 0.95, blue: 0.6)]
        case .confetti:
            return [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        case .lightning:
            return [.cyan, .white, Color(red: 0.6, green: 0.9, blue: 1.0)]
        case .fire:
            return [.red, .orange, .yellow, Color(red: 1.0, green: 0.3, blue: 0.0)]
        case .hearts:
            return [.red, .pink, Color(red: 1.0, green: 0.4, blue: 0.6)]
        case .sparkles:
            return [.white, .cyan, Color(red: 1.0, green: 1.0, blue: 0.8)]
        }
    }
}
