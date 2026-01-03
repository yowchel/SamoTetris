//
//  TetrominoType.swift
//  ModernTetris
//
//  Created on 2026-01-03
//

import Foundation

/// The seven standard Tetris pieces
enum TetrominoType: String, CaseIterable {
    case i = "I"
    case o = "O"
    case t = "T"
    case s = "S"
    case z = "Z"
    case j = "J"
    case l = "L"

    /// Get the block positions for this piece at rotation 0
    /// Positions are relative to the piece's origin (0,0)
    var baseBlocks: [Position] {
        switch self {
        case .i:
            // ####
            return [
                Position(row: 0, column: 0),
                Position(row: 0, column: 1),
                Position(row: 0, column: 2),
                Position(row: 0, column: 3)
            ]
        case .o:
            // ##
            // ##
            return [
                Position(row: 0, column: 0),
                Position(row: 0, column: 1),
                Position(row: 1, column: 0),
                Position(row: 1, column: 1)
            ]
        case .t:
            // ###
            //  #
            return [
                Position(row: 0, column: 0),
                Position(row: 0, column: 1),
                Position(row: 0, column: 2),
                Position(row: 1, column: 1)
            ]
        case .s:
            //  ##
            // ##
            return [
                Position(row: 0, column: 1),
                Position(row: 0, column: 2),
                Position(row: 1, column: 0),
                Position(row: 1, column: 1)
            ]
        case .z:
            // ##
            //  ##
            return [
                Position(row: 0, column: 0),
                Position(row: 0, column: 1),
                Position(row: 1, column: 1),
                Position(row: 1, column: 2)
            ]
        case .j:
            // #
            // ###
            return [
                Position(row: 0, column: 0),
                Position(row: 1, column: 0),
                Position(row: 1, column: 1),
                Position(row: 1, column: 2)
            ]
        case .l:
            //   #
            // ###
            return [
                Position(row: 0, column: 2),
                Position(row: 1, column: 0),
                Position(row: 1, column: 1),
                Position(row: 1, column: 2)
            ]
        }
    }

    /// Color identifier for theming
    var colorName: String {
        rawValue
    }
}
