//
//  GameViewModel.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// ViewModel for game screen
class GameViewModel: ObservableObject {
    @Published var engine = GameEngine()

    // Gesture handling
    func handleTap() {
        engine.rotate()
    }

    func handleSwipeLeft() {
        engine.moveLeft()
    }

    func handleSwipeRight() {
        engine.moveRight()
    }

    func handleSwipeDown() {
        engine.softDrop()
    }

    func handleLongPress() {
        engine.hardDrop()
    }

    func handleDoubleTap() {
        engine.hold()
    }

    // Game control
    func startGame() {
        engine.start()
    }

    func pauseGame() {
        engine.pause()
    }

    func resumeGame() {
        engine.resume()
    }
}
