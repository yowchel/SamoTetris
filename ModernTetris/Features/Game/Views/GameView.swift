//
//  GameView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Main game screen
struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.vikingBackground.ignoresSafeArea()

                VStack(spacing: 8) {
                    // Top bar with stats and pause
                    HStack(spacing: 12) {
                        // Stats
                        statsBar

                        // Pause button
                        if viewModel.engine.state == .playing {
                            Button(action: {
                                viewModel.pauseGame()
                            }) {
                                Image(systemName: "pause.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.vikingGold)
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 8)

                    // Game area with side panels
                    HStack(spacing: 8) {
                        // Hold piece - left side
                        VStack(spacing: 4) {
                            Text(LocalizedStrings.current.hold)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.vikingGold.opacity(0.7))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            HoldPieceView(
                                piece: viewModel.engine.heldPiece,
                                blockSize: 8
                            )
                            .frame(width: 45, height: 45)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(6)

                            Spacer()
                        }
                        .frame(width: 50)

                        // Game board - clean, no borders
                        BoardView(
                            board: viewModel.engine.board,
                            currentPiece: viewModel.engine.currentPiece,
                            ghostPiece: viewModel.engine.ghostPiece,
                            blockSize: calculateBlockSize(geometry: geometry)
                        )
                        .gesture(dragGesture)
                        .onTapGesture {
                            if viewModel.engine.state == .playing {
                                viewModel.handleTap()
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0.3) {
                            if viewModel.engine.state == .playing {
                                viewModel.handleLongPress()
                            }
                        }
                        .simultaneousGesture(doubleTapGesture)

                        // Next pieces - right side
                        VStack(spacing: 4) {
                            Text(LocalizedStrings.current.next)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.vikingAccent.opacity(0.7))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            NextPieceView(
                                pieces: viewModel.engine.nextPieces,
                                blockSize: 6
                            )
                            .frame(width: 45, height: 100)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(6)

                            Spacer()
                        }
                        .frame(width: 50)
                    }
                    .padding(.horizontal, 8)

                    Spacer()
                }

                // Overlays
                if viewModel.engine.state == .idle {
                    startOverlay
                }

                if viewModel.engine.state == .gameOver {
                    gameOverOverlay
                }

                if viewModel.engine.state == .paused {
                    pauseOverlay
                }
            }
        }
    }

    // MARK: - Layout Calculation

    private func calculateBlockSize(geometry: GeometryProxy) -> CGFloat {
        let topBarHeight: CGFloat = 50
        let sidePanelWidth: CGFloat = 50
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 16

        let availableHeight = geometry.size.height - topBarHeight - verticalPadding
        let availableWidth = geometry.size.width - (sidePanelWidth * 2) - (horizontalPadding * 2)

        let heightBased = availableHeight / 20
        let widthBased = availableWidth / 10

        let calculatedSize = min(heightBased, widthBased)

        // Ensure valid size (positive and finite)
        return max(1, calculatedSize.isFinite ? calculatedSize : 20)
    }

    // MARK: - UI Components

    private var statsBar: some View {
        HStack(spacing: 16) {
            statItem(label: LocalizedStrings.current.score, value: "\(viewModel.engine.score)", color: .vikingGold)
            Spacer()
            statItem(label: LocalizedStrings.current.lines, value: "\(viewModel.engine.linesCleared)", color: .white)
            Spacer()
            statItem(label: LocalizedStrings.current.tetris, value: "\(viewModel.engine.tetrisCount)", color: .vikingAccent)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.vikingWood.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.vikingGold.opacity(0.4), lineWidth: 2)
                )
        )
    }

    private func statItem(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
            Text(value)
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(color)
        }
    }

    // MARK: - Overlays

    private var startOverlay: some View {
        VStack(spacing: 20) {
            Text(LocalizedStrings.current.appTitle)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.vikingGold)
                .shadow(color: .vikingGold.opacity(0.5), radius: 10)

            // Controls guide
            VStack(alignment: .leading, spacing: 10) {
                Text(LocalizedStrings.current.controls)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.vikingGold.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 6) {
                    controlHint(icon: "arrow.left.and.right", text: LocalizedStrings.current.swipeLeftRight)
                    controlHint(icon: "arrow.down", text: LocalizedStrings.current.swipeDown)
                    controlHint(icon: "hand.tap", text: LocalizedStrings.current.tap)
                    controlHint(icon: "hand.point.up", text: LocalizedStrings.current.longPress)
                    controlHint(icon: "hand.tap.fill", text: LocalizedStrings.current.doubleTap)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )

            Button(action: {
                viewModel.startGame()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "play.fill")
                    Text(LocalizedStrings.current.startBattle)
                }
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.vikingGold, Color(red: 0.7, green: 0.55, blue: 0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .vikingGold.opacity(0.6), radius: 12)
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.vikingGold, .vikingGold.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 20)
        )
    }

    private func controlHint(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.vikingAccent)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
        }
    }

    private var gameOverOverlay: some View {
        VStack(spacing: 20) {
            Text(LocalizedStrings.current.defeated)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.dangerColor)
                .shadow(color: .dangerColor.opacity(0.5), radius: 10)

            Text("\(LocalizedStrings.current.finalScore) \(viewModel.engine.score)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                Button(action: {
                    viewModel.startGame()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text(LocalizedStrings.current.playAgain)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.vikingGold, .vikingGold.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .vikingGold.opacity(0.4), radius: 8)
                }

                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "house.fill")
                        Text(LocalizedStrings.current.mainMenu)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.buttonGray, .buttonGray.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.dangerColor.opacity(0.6), lineWidth: 3)
                )
        )
    }

    private var pauseOverlay: some View {
        VStack(spacing: 20) {
            Text(LocalizedStrings.current.paused)
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.vikingAccent)

            VStack(spacing: 12) {
                Button(action: {
                    viewModel.resumeGame()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(LocalizedStrings.current.resume)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.successColor, .successColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .successColor.opacity(0.4), radius: 8)
                }

                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "house.fill")
                        Text(LocalizedStrings.current.mainMenu)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.buttonGray, .buttonGray.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.vikingAccent.opacity(0.6), lineWidth: 3)
                )
        )
    }

    // MARK: - Gestures (still work for swipe players)

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let horizontalMovement = value.translation.width
                let verticalMovement = value.translation.height

                if abs(horizontalMovement) > abs(verticalMovement) {
                    if horizontalMovement > 0 {
                        viewModel.handleSwipeRight()
                    } else {
                        viewModel.handleSwipeLeft()
                    }
                } else {
                    if verticalMovement > 0 {
                        viewModel.handleSwipeDown()
                    }
                }
            }
    }

    private var doubleTapGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                viewModel.handleDoubleTap()
            }
    }
}

#Preview {
    GameView()
}
