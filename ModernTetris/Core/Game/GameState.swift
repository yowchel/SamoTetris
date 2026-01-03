//
//  GameState.swift
//  ModernTetris
//
//  Created on 2026-01-03
//

import Foundation

/// Represents the current state of the game
enum GameState: Equatable, Sendable {
    case idle        // Not started
    case playing     // Active game
    case paused      // Paused
    case gameOver    // Game ended
}
