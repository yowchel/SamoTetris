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
    @ObservedObject private var shopManager = ShopManager.shared
    @ObservedObject private var audioManager = AudioManager.shared

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.vikingBackground.ignoresSafeArea()

                // Background animation based on selected type - more pieces for game screen
                Group {
                    switch shopManager.currentBackgroundAnimation {
                    case .tetromino:
                        FallingTetrominoBackground(isGameScreen: true)
                    case .bubbles:
                        BubblesBackground(isGameScreen: true)
                    case .particles:
                        ParticlesBackground(isGameScreen: true)
                    }
                }
                .ignoresSafeArea()
                .opacity(0.3)

                VStack(spacing: 0) {
                    // Top bar with Pause button (44x44 Apple standard) - centered
                    HStack {
                        Spacer()

                        Button(action: {
                            if viewModel.engine.state == .playing {
                                audioManager.buttonClick()
                                viewModel.pauseGame()
                            }
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.vikingGold)
                                .frame(width: 44, height: 44)
                        }
                        .opacity(viewModel.engine.state == .playing ? 1 : 0)
                        .disabled(viewModel.engine.state != .playing)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    .frame(height: 68)

                    // Main game area
                    HStack(spacing: 8) {
                        // Left panel - Hold + Stats
                        VStack(spacing: 0) {
                            // HOLD section
                            VStack(spacing: 0) {
                                Text(LocalizedStrings.current.hold)
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundColor(.primaryText)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                                    .background(Color.vikingWood.opacity(0.9))

                                HoldPieceView(
                                    piece: viewModel.engine.heldPiece,
                                    blockSize: 7
                                )
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                            .background(Color.boardBackground.opacity(0.6))
                            .overlay(
                                Rectangle()
                                    .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )

                            Spacer()
                                .frame(height: 8)

                            // SCORE section
                            VStack(spacing: 4) {
                                Text(LocalizedStrings.current.score)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 6)

                                Text("\(viewModel.engine.score)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.vikingGold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 6)
                            }
                            .background(Color.boardBackground.opacity(0.6))
                            .overlay(
                                Rectangle()
                                    .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )

                            Spacer()
                                .frame(height: 8)

                            // TETRIS section
                            VStack(spacing: 4) {
                                Text(LocalizedStrings.current.tetris)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 6)

                                Text("\(viewModel.engine.tetrisCount)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.dangerColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 6)
                            }
                            .background(Color.boardBackground.opacity(0.6))
                            .overlay(
                                Rectangle()
                                    .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )

                            Spacer()
                                .frame(height: 8)

                            // LINES section
                            VStack(spacing: 4) {
                                Text(LocalizedStrings.current.lines)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 6)

                                Text("\(viewModel.engine.linesCleared)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 6)
                            }
                            .background(Color.boardBackground.opacity(0.6))
                            .overlay(
                                Rectangle()
                                    .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )

                            Spacer()
                        }
                        .frame(width: 70)

                        // Main board
                        ZStack {
                            BoardView(
                                board: viewModel.engine.board,
                                currentPiece: viewModel.engine.currentPiece,
                                ghostPiece: viewModel.engine.ghostPiece,
                                blockSize: calculateBlockSize(geometry: geometry),
                                clearingLines: viewModel.engine.clearingLines
                            )
                            .overlay(
                                Group {
                                    if let frame = shopManager.currentBoardFrame {
                                        AnimatedBoardFrame(frame: frame)
                                    }
                                }
                            )
                        }
                        .overlay(
                            Rectangle()
                                .strokeBorder(Color.primaryText.opacity(0.3), lineWidth: 2)
                        )
                        .gesture(dragGesture)
                        .onTapGesture {
                            if viewModel.engine.state == .playing {
                                viewModel.handleTap()
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0.3) {
                            if viewModel.engine.state == .playing {
                                viewModel.handleDoubleTap()  // Long press now does HOLD instead of hard drop
                            }
                        }

                        // Right panel - Next (3 pieces) - same height as left HOLD section only
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Text(LocalizedStrings.current.next)
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundColor(.primaryText)
                                    .textCase(.uppercase)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                                    .background(Color.vikingWood.opacity(0.9))

                                // Show 3 next pieces vertically
                                VStack(spacing: 6) {
                                    ForEach(Array(viewModel.engine.nextPieces.prefix(3).enumerated()), id: \.offset) { index, type in
                                        NextPieceSingleView(
                                            type: type,
                                            blockSize: 6
                                        )
                                        .frame(height: 36)
                                        .frame(maxWidth: .infinity)
                                        .opacity(index == 0 ? 1.0 : 0.7)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .background(Color.boardBackground.opacity(0.6))
                            .overlay(
                                Rectangle()
                                    .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )

                            Spacer()
                        }
                        .frame(width: 70)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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
        let topBarHeight: CGFloat = 68  // Pause button bar (centered, more space)
        let sidePanelWidth: CGFloat = 70  // Side panels
        let horizontalPadding: CGFloat = 48  // 16 + 16 + 8 + 8
        let verticalPadding: CGFloat = 16
        let boardInnerPadding: CGFloat = 12

        let availableHeight = geometry.size.height - topBarHeight - verticalPadding - boardInnerPadding
        let availableWidth = geometry.size.width - (sidePanelWidth * 2) - horizontalPadding

        let heightBased = availableHeight / 20
        let widthBased = availableWidth / 10

        let calculatedSize = min(heightBased, widthBased)

        return max(1, calculatedSize.isFinite ? calculatedSize : 17)
    }

    // MARK: - Overlays

    private var startOverlay: some View {
        VStack(spacing: 16) {
            Text(LocalizedStrings.current.appTitle)
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.titleText)
                .shadow(color: .titleText.opacity(0.5), radius: 10)

            // Controls guide - COMPACT
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.current.controls)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.titleText.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 4) {
                    controlHint(icon: "arrow.left.and.right", text: LocalizedStrings.current.swipeLeftRight)
                    controlHint(icon: "arrow.down", text: LocalizedStrings.current.swipeDown)
                    controlHint(icon: "hand.tap", text: LocalizedStrings.current.tap)
                    controlHint(icon: "hand.point.up", text: LocalizedStrings.current.longPress)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.boardBackground.opacity(0.6))
            )

            Button(action: {
                audioManager.buttonClick()
                viewModel.startGame()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .frame(width: 20)
                    Text(LocalizedStrings.current.startBattle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.playButtonTextColor)
                .frame(width: 220, height: 44)
                .background(
                    LinearGradient(
                        colors: [.playButtonColor, .playButtonColor.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: .playButtonColor.opacity(0.6), radius: 8)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.vikingGold, .vikingGold.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.boardBackground.opacity(0.8), radius: 15)
        )
        .frame(maxWidth: 320)
    }

    private func controlHint(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(.vikingAccent)
                .frame(width: 18)
            Text(text)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var gameOverOverlay: some View {
        VStack(spacing: 20) {
            Text(LocalizedStrings.current.defeated)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.dangerColor)
                .shadow(color: .dangerColor.opacity(0.5), radius: 10)

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text(LocalizedStrings.current.score)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondaryText)
                    Text("\(viewModel.engine.score)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.vikingGold)
                }

                HStack(spacing: 12) {
                    Text(LocalizedStrings.current.lines)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondaryText)
                    Text("\(viewModel.engine.linesCleared)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primaryText)
                }
            }

            HStack(spacing: 16) {
                Button(action: {
                    audioManager.buttonClick()
                    // Coins already awarded in gameOver(), just dismiss
                    dismiss()
                }) {
                    Text(LocalizedStrings.current.mainMenu)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: 130, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.vikingWood.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.primaryText.opacity(0.3), lineWidth: 1.5)
                                )
                        )
                }

                Button(action: {
                    audioManager.buttonClick()
                    viewModel.startGame()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 18)
                        Text(LocalizedStrings.current.playAgain)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.playButtonTextColor)
                    .frame(width: 130, height: 44)
                    .background(
                        LinearGradient(
                            colors: [.playButtonColor, .playButtonColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .playButtonColor.opacity(0.6), radius: 6)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.dangerColor, .dangerColor.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.boardBackground.opacity(0.8), radius: 15)
        )
        .frame(maxWidth: 320)
    }

    private var pauseOverlay: some View {
        VStack(spacing: 20) {
            Text(LocalizedStrings.current.paused)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.titleText)
                .shadow(color: .titleText.opacity(0.5), radius: 10)

            VStack(spacing: 16) {
                Button(action: {
                    audioManager.buttonClick()
                    viewModel.resumeGame()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .frame(width: 20)
                        Text(LocalizedStrings.current.resume)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.playButtonTextColor)
                    .frame(width: 220, height: 48)
                    .background(
                        LinearGradient(
                            colors: [.playButtonColor, .playButtonColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .playButtonColor.opacity(0.6), radius: 8)
                }

                Button(action: {
                    audioManager.buttonClick()
                    // Award coins before exiting from paused game
                    viewModel.finishGame()
                    dismiss()
                }) {
                    Text(LocalizedStrings.current.mainMenu)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: 220, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.vikingWood.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(Color.primaryText.opacity(0.3), lineWidth: 1.5)
                                )
                        )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vikingWood.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.vikingGold, .vikingGold.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.boardBackground.opacity(0.8), radius: 15)
        )
        .frame(maxWidth: 280)
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                guard viewModel.engine.state == .playing else { return }

                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height

                if abs(horizontalAmount) > abs(verticalAmount) {
                    // Horizontal swipe
                    if horizontalAmount > 0 {
                        viewModel.handleSwipeRight()
                    } else {
                        viewModel.handleSwipeLeft()
                    }
                } else {
                    // Vertical swipe
                    if verticalAmount > 0 {
                        viewModel.handleSwipeDown()
                    }
                }
            }
    }

}

#Preview {
    GameView()
}
