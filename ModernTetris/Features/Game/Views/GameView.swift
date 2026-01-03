//
//  GameView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Main game screen
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    private let blockSize: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.black, Color(white: 0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    headerView

                    // Game area
                    HStack(spacing: 16) {
                        // Hold piece
                        HoldPieceView(
                            piece: viewModel.engine.heldPiece,
                            blockSize: blockSize
                        )

                        // Board
                        BoardView(
                            board: viewModel.engine.board,
                            currentPiece: viewModel.engine.currentPiece,
                            blockSize: blockSize
                        )
                        .gesture(dragGesture)
                        .onTapGesture {
                            viewModel.handleTap()
                        }
                        .onLongPressGesture(minimumDuration: 0.3) {
                            viewModel.handleLongPress()
                        }
                        .simultaneousGesture(doubleTapGesture)

                        // Next pieces
                        NextPieceView(
                            pieces: viewModel.engine.nextPieces,
                            blockSize: blockSize
                        )
                    }

                    // Controls info
                    if viewModel.engine.state == .idle {
                        controlsHintView
                    }

                    Spacer()

                    // Start button
                    if viewModel.engine.state == .idle || viewModel.engine.state == .gameOver {
                        Button(action: {
                            viewModel.startGame()
                        }) {
                            Text(viewModel.engine.state == .gameOver ? "PLAY AGAIN" : "START GAME")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: 200)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }

                    if viewModel.engine.state == .playing {
                        Button(action: {
                            viewModel.pauseGame()
                        }) {
                            Text("PAUSE")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: 150)
                                .padding(.vertical, 8)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                    }

                    if viewModel.engine.state == .paused {
                        Button(action: {
                            viewModel.resumeGame()
                        }) {
                            Text("RESUME")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: 150)
                                .padding(.vertical, 8)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("SAMOTETRIS")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 40) {
                VStack {
                    Text("SCORE")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(viewModel.engine.score)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack {
                    Text("LINES")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(viewModel.engine.linesCleared)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack {
                    Text("TETRIS")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(viewModel.engine.tetrisCount)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.yellow)
                }
            }
        }
    }

    private var controlsHintView: some View {
        VStack(spacing: 8) {
            Text("CONTROLS")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.7))

            VStack(alignment: .leading, spacing: 4) {
                Text("← → Swipe: Move")
                Text("↓ Swipe: Soft Drop")
                Text("Tap: Rotate")
                Text("Long Press: Hard Drop")
                Text("Double Tap: Hold")
            }
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let horizontalMovement = value.translation.width
                let verticalMovement = value.translation.height

                if abs(horizontalMovement) > abs(verticalMovement) {
                    // Horizontal swipe
                    if horizontalMovement > 0 {
                        viewModel.handleSwipeRight()
                    } else {
                        viewModel.handleSwipeLeft()
                    }
                } else {
                    // Vertical swipe
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
