//
//  GameViewModel.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI
import Combine

/// ViewModel for game screen
@MainActor
final class GameViewModel: ObservableObject {
    @Published var engine = GameEngine()

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Forward engine changes to this ViewModel
        engine.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }

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
        _ = engine.softDrop()
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

    func finishGame() {
        engine.finishGame()
    }
}
