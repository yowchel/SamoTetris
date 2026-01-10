//
//  FallingTetromino.swift
//  SamoTetris
//
//  Created on 2026-01-05
//

import SwiftUI

/// Single falling tetromino piece for background animation
struct FallingTetromino: View {
    let type: TetrominoType
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let duration: Double
    let rotationSpeed: Double

    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        TetrominoShape(type: type)
            .fill(Color.forTetromino(type))
            .frame(width: size, height: size)
            .opacity(0.15)
            .rotationEffect(.degrees(rotation))
            .offset(x: startX, y: yOffset)
            .onAppear {
                // Start from initial Y position
                yOffset = startY

                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    yOffset = UIScreen.main.bounds.height + 100
                }

                withAnimation(.linear(duration: rotationSpeed).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

/// Shape representing a tetromino piece
struct TetrominoShape: Shape {
    let type: TetrominoType

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let blockSize = rect.width / 4

        // Get block positions for this tetromino type
        let blocks = getBlocks(for: type)

        for block in blocks {
            let x = CGFloat(block.column) * blockSize
            let y = CGFloat(block.row) * blockSize
            let blockRect = CGRect(x: x, y: y, width: blockSize, height: blockSize)
            path.addRoundedRect(in: blockRect, cornerSize: CGSize(width: 2, height: 2))
        }

        return path
    }

    /// Get block positions for tetromino type (relative to 4x4 grid)
    private func getBlocks(for type: TetrominoType) -> [Position] {
        switch type {
        case .i:
            return [Position(row: 1, column: 0), Position(row: 1, column: 1),
                    Position(row: 1, column: 2), Position(row: 1, column: 3)]
        case .o:
            return [Position(row: 1, column: 1), Position(row: 1, column: 2),
                    Position(row: 2, column: 1), Position(row: 2, column: 2)]
        case .t:
            return [Position(row: 1, column: 1), Position(row: 2, column: 0),
                    Position(row: 2, column: 1), Position(row: 2, column: 2)]
        case .s:
            return [Position(row: 1, column: 1), Position(row: 1, column: 2),
                    Position(row: 2, column: 0), Position(row: 2, column: 1)]
        case .z:
            return [Position(row: 1, column: 0), Position(row: 1, column: 1),
                    Position(row: 2, column: 1), Position(row: 2, column: 2)]
        case .j:
            return [Position(row: 1, column: 0), Position(row: 2, column: 0),
                    Position(row: 2, column: 1), Position(row: 2, column: 2)]
        case .l:
            return [Position(row: 1, column: 2), Position(row: 2, column: 0),
                    Position(row: 2, column: 1), Position(row: 2, column: 2)]
        }
    }
}

/// Background view with multiple falling tetromino pieces
struct FallingTetrominoBackground: View {
    @State private var pieces: [FallingPieceData] = []
    var isGameScreen: Bool = false  // Use more pieces for game screen

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(pieces) { piece in
                    FallingTetromino(
                        type: piece.type,
                        size: piece.size,
                        startX: piece.startX,
                        startY: piece.startY,
                        duration: piece.duration,
                        rotationSpeed: piece.rotationSpeed
                    )
                }
            }
            .onAppear {
                generatePieces(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
            }
        }
    }

    private func generatePieces(screenWidth: CGFloat, screenHeight: CGFloat) {
        // Generate more pieces for game screen (20-25) vs menu (12-16)
        let count = isGameScreen ? Int.random(in: 20...25) : Int.random(in: 12...16)

        for _ in 0..<count {
            let type = TetrominoType.allCases.randomElement() ?? .i
            // Larger pieces for game screen for better visibility
            let size = isGameScreen ? CGFloat.random(in: 70...110) : CGFloat.random(in: 60...90)
            let startX = CGFloat.random(in: -50...(screenWidth - 50))
            // Start from random Y position ABOVE the screen (negative values)
            // Range from -screenHeight to -100 ensures all pieces start above screen
            let startY = CGFloat.random(in: -screenHeight...(-100))
            // Slower for game screen
            let duration = isGameScreen ? Double.random(in: 10...18) : Double.random(in: 8...15)
            let rotationSpeed = isGameScreen ? Double.random(in: 12...22) : Double.random(in: 10...20)

            let piece = FallingPieceData(
                type: type,
                size: size,
                startX: startX,
                startY: startY,
                duration: duration,
                rotationSpeed: rotationSpeed
            )

            pieces.append(piece)
        }
    }
}

/// Data model for a falling piece
struct FallingPieceData: Identifiable {
    let id = UUID()
    let type: TetrominoType
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let duration: Double
    let rotationSpeed: Double
}
