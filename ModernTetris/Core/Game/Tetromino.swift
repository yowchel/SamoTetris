//
//  Tetromino.swift
//  ModernTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Represents a Tetris piece with position and rotation
struct Tetromino: Sendable {
    let type: TetrominoType
    var position: Position
    var rotation: Int // 0, 1, 2, 3 (0° 90° 180° 270°)

    init(type: TetrominoType, position: Position = Position(row: 0, column: 3), rotation: Int = 0) {
        self.type = type
        self.position = position
        self.rotation = rotation
    }

    /// Get all block positions for this piece in its current state
    var blocks: [Position] {
        let baseBlocks = type.baseBlocks

        // O piece doesn't rotate
        if type == .o {
            return baseBlocks.map { $0.moved(by: position) }
        }

        // Apply rotation
        let rotatedBlocks = baseBlocks.map { block -> Position in
            var rotated = block

            // Rotate around origin (0,0)
            // Apply rotation count times
            for _ in 0..<rotation {
                let newRow = rotated.column
                let newColumn = -rotated.row
                rotated = Position(row: newRow, column: newColumn)
            }

            return rotated
        }

        // Translate to world position
        return rotatedBlocks.map { $0.moved(by: position) }
    }

    /// Create a copy rotated clockwise
    func rotated() -> Tetromino {
        var piece = self
        piece.rotation = (rotation + 1) % 4
        return piece
    }

    /// Create a copy moved by offset
    func moved(by offset: Position) -> Tetromino {
        var piece = self
        piece.position = position.moved(by: offset)
        return piece
    }

    /// Create a copy moved down
    func movedDown() -> Tetromino {
        var piece = self
        piece.position = position.movedDown()
        return piece
    }

    /// Create a copy moved left
    func movedLeft() -> Tetromino {
        var piece = self
        piece.position = position.movedLeft()
        return piece
    }

    /// Create a copy moved right
    func movedRight() -> Tetromino {
        var piece = self
        piece.position = position.movedRight()
        return piece
    }
}
