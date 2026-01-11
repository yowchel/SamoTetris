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

        // Base coins from score (improved: was /10, now /8 = +25% more coins)
        coinsEarned += score / 8

        // Bonus for lines cleared (improved: was x5, now x8 = +60% per line)
        coinsEarned += linesCleared * 8

        // Extra bonus for Tetris (improved: was x50, now x100 = double reward)
        coinsEarned += tetrisCount * 100

        return max(15, coinsEarned) // Minimum 15 coins per game (was 10)
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
