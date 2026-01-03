//
//  ScoreManager.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Manages score calculation
struct ScoreManager {

    /// Calculate score for clearing lines
    static func scoreForLines(count: Int) -> Int {
        switch count {
        case 1:
            return GameConstants.scoreOneLine
        case 2:
            return GameConstants.scoreTwoLines
        case 3:
            return GameConstants.scoreThreeLines
        case 4:
            return GameConstants.scoreFourLines
        default:
            return 0
        }
    }

    /// Calculate score for soft drop
    static func scoreForSoftDrop(cells: Int) -> Int {
        return cells * GameConstants.scoreSoftDropPerCell
    }

    /// Calculate score for hard drop
    static func scoreForHardDrop(cells: Int) -> Int {
        return cells * GameConstants.scoreHardDropPerCell
    }

    /// Check if line count is a Tetris (4 lines)
    static func isTetris(lineCount: Int) -> Bool {
        return lineCount == 4
    }
}
