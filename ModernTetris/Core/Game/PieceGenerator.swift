//
//  PieceGenerator.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Generates pieces using the 7-bag randomization algorithm
/// This ensures fair distribution - you'll see all 7 pieces within every 7 pieces
class PieceGenerator {
    private var bag: [TetrominoType] = []
    private var nextPieces: [TetrominoType] = []

    private let previewCount = 5  // Show next 5 pieces

    init() {
        fillBag()
        fillBag()  // Fill twice to have enough for preview
        generatePreview()
    }

    /// Get the next piece
    func next() -> TetrominoType {
        // Refill bag if running low
        if bag.count < previewCount {
            fillBag()
        }

        let piece = bag.removeFirst()
        generatePreview()
        return piece
    }

    /// Get preview of next pieces
    func preview() -> [TetrominoType] {
        return nextPieces
    }

    /// Fill the bag with all 7 pieces in random order
    private func fillBag() {
        var newBag = TetrominoType.allCases
        newBag.shuffle()
        bag.append(contentsOf: newBag)
    }

    /// Update the preview array
    private func generatePreview() {
        nextPieces = Array(bag.prefix(previewCount))
    }

    /// Reset generator
    func reset() {
        bag = []
        nextPieces = []
        fillBag()
        fillBag()
        generatePreview()
    }
}
