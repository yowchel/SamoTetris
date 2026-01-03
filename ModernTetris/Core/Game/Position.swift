//
//  Position.swift
//  ModernTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Represents a position on the game board
struct Position: Equatable, Hashable, Sendable {
    var row: Int
    var column: Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    /// Move position by offset
    func moved(by offset: Position) -> Position {
        Position(row: row + offset.row, column: column + offset.column)
    }

    /// Move down by one row
    func movedDown() -> Position {
        Position(row: row + 1, column: column)
    }

    /// Move left by one column
    func movedLeft() -> Position {
        Position(row: row, column: column - 1)
    }

    /// Move right by one column
    func movedRight() -> Position {
        Position(row: row, column: column + 1)
    }
}
