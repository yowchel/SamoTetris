//
//  CurrencyManager.swift
//  SamoTetris
//
//  Created on 2026-01-04
//

import Foundation
import SwiftUI

/// Manages in-game currency (coins)
class CurrencyManager: ObservableObject {
    @AppStorage("totalCoins") private var storedCoins: Int = 0
    @Published var coins: Int = 0

    static let shared = CurrencyManager()

    private init() {
        coins = storedCoins
    }

    /// Add coins to the player's balance
    func addCoins(_ amount: Int) {
        coins += amount
        storedCoins = coins
    }

    /// Try to spend coins. Returns true if successful, false if not enough coins
    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        storedCoins = coins
        return true
    }

    /// Calculate coins earned from a game
    func calculateCoinsEarned(score: Int, linesCleared: Int, tetrisCount: Int) -> Int {
        var coinsEarned = 0

        // Base coins from score
        coinsEarned += score / 10

        // Bonus for lines cleared
        coinsEarned += linesCleared * 5

        // Extra bonus for Tetris (4 lines at once)
        coinsEarned += tetrisCount * 50

        return max(10, coinsEarned) // Minimum 10 coins per game
    }

    /// Award coins after a game
    func awardGameCoins(score: Int, linesCleared: Int, tetrisCount: Int) -> Int {
        let earned = calculateCoinsEarned(score: score, linesCleared: linesCleared, tetrisCount: tetrisCount)
        addCoins(earned)
        return earned
    }

    /// Add test coins for development (removes in production)
    func addTestCoins() {
        addCoins(5000)
    }
}
