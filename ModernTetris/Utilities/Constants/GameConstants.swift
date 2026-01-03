//
//  GameConstants.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation

enum GameConstants {
    // Board dimensions
    static let boardWidth = 10
    static let boardHeight = 20

    // Game timing (in seconds)
    static let dropInterval: TimeInterval = 1.0  // Constant speed - no levels

    // Scoring
    static let scoreOneLine = 100
    static let scoreTwoLines = 300
    static let scoreThreeLines = 500
    static let scoreFourLines = 800  // Tetris!

    static let scoreSoftDropPerCell = 1
    static let scoreHardDropPerCell = 2

    // Starting position for new pieces
    static let startColumn = 3
    static let startRow = 0
}
