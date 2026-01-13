//
//  ShopManager.swift
//  SamoTetris
//
//  Created on 2026-01-04
//

import Foundation
import SwiftUI

/// Manages shop purchases and unlocked items
class ShopManager: ObservableObject {
    @AppStorage("unlockedParticleEffects") private var unlockedParticleEffectsData: String = "[]"
    @AppStorage("unlockedBoardFrames") private var unlockedBoardFramesData: String = "[\"Classic\"]"  // Classic is free by default
    @AppStorage("unlockedThemes") private var unlockedThemesData: String = "[\"Noir\"]"  // Noir is free by default
    @AppStorage("unlockedBackgroundAnimations") private var unlockedBackgroundAnimationsData: String = "[\"Tetromino\"]"  // Tetromino is free by default
    @AppStorage("selectedParticleEffect") private var selectedEffect: String = ""
    @AppStorage("selectedBoardFrame") private var selectedFrame: String = "Classic"  // Classic selected by default
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = "Noir"
    @AppStorage("selectedBackgroundAnimation") private var selectedBackgroundAnim: String = "Tetromino"  // Tetromino selected by default

    @Published var unlockedParticleEffects: Set<ParticleEffect> = []
    @Published var unlockedBoardFrames: Set<BoardFrame> = [.classic]  // Classic is always unlocked
    @Published var unlockedThemes: Set<GameTheme> = [.noir]  // Noir is always unlocked
    @Published var unlockedBackgroundAnimations: Set<BackgroundAnimation> = [.tetromino]  // Tetromino is always unlocked
    @Published var currentParticleEffect: ParticleEffect?
    @Published var currentBoardFrame: BoardFrame? = .classic  // Classic by default
    @Published var currentTheme: GameTheme = .noir
    @Published var currentBackgroundAnimation: BackgroundAnimation = .tetromino  // Tetromino by default

    static let shared = ShopManager()

    private init() {
        loadUnlockedItems()

        // Ensure Noir is selected by default if no theme is set OR if current theme is not unlocked
        if selectedThemeRaw.isEmpty || selectedThemeRaw == "" {
            selectedThemeRaw = "Noir"
            currentTheme = .noir
        } else if let theme = GameTheme(rawValue: selectedThemeRaw), !unlockedThemes.contains(theme) {
            // Reset to Noir if current theme is not unlocked (e.g., from old version)
            selectedThemeRaw = "Noir"
            currentTheme = .noir
        }

        // Ensure Classic frame is selected by default if no frame is set OR if current frame is not unlocked
        if selectedFrame.isEmpty || selectedFrame == "" {
            selectedFrame = "Classic"
            currentBoardFrame = .classic
        } else if let frame = BoardFrame(rawValue: selectedFrame), !unlockedBoardFrames.contains(frame) {
            // Reset to Classic if current frame is not unlocked (e.g., from old version)
            selectedFrame = "Classic"
            currentBoardFrame = .classic
        }

        // Ensure Tetromino animation is selected by default if no animation is set OR if current animation is not unlocked
        if selectedBackgroundAnim.isEmpty || selectedBackgroundAnim == "" {
            selectedBackgroundAnim = "Tetromino"
            currentBackgroundAnimation = .tetromino
        } else if let animation = BackgroundAnimation(rawValue: selectedBackgroundAnim), !unlockedBackgroundAnimations.contains(animation) {
            // Reset to Tetromino if current animation is not unlocked
            selectedBackgroundAnim = "Tetromino"
            currentBackgroundAnimation = .tetromino
        }
    }

    // MARK: - Load/Save

    private func loadUnlockedItems() {
        // Load particle effects
        if let data = unlockedParticleEffectsData.data(using: .utf8),
           let effects = try? JSONDecoder().decode([String].self, from: data) {
            unlockedParticleEffects = Set(effects.compactMap { ParticleEffect(rawValue: $0) })
        }

        // Load board frames (Classic is always unlocked)
        if let data = unlockedBoardFramesData.data(using: .utf8),
           let frames = try? JSONDecoder().decode([String].self, from: data) {
            unlockedBoardFrames = Set(frames.compactMap { BoardFrame(rawValue: $0) })
        }
        if !unlockedBoardFrames.contains(.classic) {
            unlockedBoardFrames.insert(.classic)
        }

        // Load themes (Noir is always unlocked)
        if let data = unlockedThemesData.data(using: .utf8),
           let themes = try? JSONDecoder().decode([String].self, from: data) {
            unlockedThemes = Set(themes.compactMap { GameTheme(rawValue: $0) })
        }
        if !unlockedThemes.contains(.noir) {
            unlockedThemes.insert(.noir)
        }

        // Load background animations (Tetromino is always unlocked)
        if let data = unlockedBackgroundAnimationsData.data(using: .utf8),
           let animations = try? JSONDecoder().decode([String].self, from: data) {
            unlockedBackgroundAnimations = Set(animations.compactMap { BackgroundAnimation(rawValue: $0) })
        }
        if !unlockedBackgroundAnimations.contains(.tetromino) {
            unlockedBackgroundAnimations.insert(.tetromino)
        }

        // Load selected items
        if let effect = ParticleEffect(rawValue: selectedEffect) {
            currentParticleEffect = effect
        }
        if let frame = BoardFrame(rawValue: selectedFrame) {
            currentBoardFrame = frame
        }
        if let theme = GameTheme(rawValue: selectedThemeRaw) {
            currentTheme = theme
        }
        if let animation = BackgroundAnimation(rawValue: selectedBackgroundAnim) {
            currentBackgroundAnimation = animation
        }
    }

    private func saveUnlockedItems() {
        // Save particle effects
        let effectsArray = Array(unlockedParticleEffects.map { $0.rawValue })
        if let data = try? JSONEncoder().encode(effectsArray),
           let string = String(data: data, encoding: .utf8) {
            unlockedParticleEffectsData = string
        }

        // Save board frames
        let framesArray = Array(unlockedBoardFrames.map { $0.rawValue })
        if let data = try? JSONEncoder().encode(framesArray),
           let string = String(data: data, encoding: .utf8) {
            unlockedBoardFramesData = string
        }

        // Save themes
        let themesArray = Array(unlockedThemes.map { $0.rawValue })
        if let data = try? JSONEncoder().encode(themesArray),
           let string = String(data: data, encoding: .utf8) {
            unlockedThemesData = string
        }

        // Save background animations
        let animationsArray = Array(unlockedBackgroundAnimations.map { $0.rawValue })
        if let data = try? JSONEncoder().encode(animationsArray),
           let string = String(data: data, encoding: .utf8) {
            unlockedBackgroundAnimationsData = string
        }
    }

    // MARK: - Purchase

    /// Try to purchase a particle effect
    func purchaseParticleEffect(_ effect: ParticleEffect) -> Bool {
        guard !unlockedParticleEffects.contains(effect) else { return false }

        if CurrencyManager.shared.spendCoins(effect.price) {
            unlockedParticleEffects.insert(effect)
            saveUnlockedItems()
            return true
        }
        return false
    }

    /// Try to purchase a board frame
    func purchaseBoardFrame(_ frame: BoardFrame) -> Bool {
        guard !unlockedBoardFrames.contains(frame) else { return false }
        guard !frame.isFree else { return false }  // Can't purchase free frames

        if CurrencyManager.shared.spendCoins(frame.price) {
            unlockedBoardFrames.insert(frame)
            saveUnlockedItems()
            return true
        }
        return false
    }

    /// Try to purchase a theme
    func purchaseTheme(_ theme: GameTheme) -> Bool {
        guard !unlockedThemes.contains(theme) else { return false }
        guard !theme.isFree else { return false }  // Can't purchase free themes

        if CurrencyManager.shared.spendCoins(theme.price) {
            unlockedThemes.insert(theme)
            saveUnlockedItems()
            return true
        }
        return false
    }

    /// Try to purchase a background animation
    func purchaseBackgroundAnimation(_ animation: BackgroundAnimation) -> Bool {
        guard !unlockedBackgroundAnimations.contains(animation) else { return false }
        guard !animation.isFree else { return false }  // Can't purchase free animations

        if CurrencyManager.shared.spendCoins(animation.price) {
            unlockedBackgroundAnimations.insert(animation)
            saveUnlockedItems()
            return true
        }
        return false
    }

    // MARK: - Selection

    /// Select a particle effect
    func selectParticleEffect(_ effect: ParticleEffect?) {
        currentParticleEffect = effect
        selectedEffect = effect?.rawValue ?? ""
    }

    /// Select a board frame
    func selectBoardFrame(_ frame: BoardFrame?) {
        currentBoardFrame = frame
        selectedFrame = frame?.rawValue ?? ""
    }

    /// Select a theme
    func selectTheme(_ theme: GameTheme) {
        guard unlockedThemes.contains(theme) else { return }
        currentTheme = theme
        selectedThemeRaw = theme.rawValue

        // Update ThemeManager to sync title colors
        ThemeManager.shared.setTheme(theme)

        // Force UI refresh by triggering objectWillChange
        objectWillChange.send()
    }

    /// Select a background animation
    func selectBackgroundAnimation(_ animation: BackgroundAnimation) {
        guard unlockedBackgroundAnimations.contains(animation) else { return }
        currentBackgroundAnimation = animation
        selectedBackgroundAnim = animation.rawValue

        // Force UI refresh by triggering objectWillChange
        objectWillChange.send()
    }

    // MARK: - Check ownership

    func isUnlocked(_ effect: ParticleEffect) -> Bool {
        return unlockedParticleEffects.contains(effect)
    }

    func isUnlocked(_ frame: BoardFrame) -> Bool {
        return unlockedBoardFrames.contains(frame)
    }

    func isUnlocked(_ theme: GameTheme) -> Bool {
        return unlockedThemes.contains(theme)
    }

    func isUnlocked(_ animation: BackgroundAnimation) -> Bool {
        return unlockedBackgroundAnimations.contains(animation)
    }

    // MARK: - Get all shop items

    func getAllShopItems() -> [ShopItem] {
        var items: [ShopItem] = []

        // Themes (only paid ones in shop)
        for theme in GameTheme.allCases.filter({ !$0.isFree }) {
            items.append(ShopItem(
                id: "theme_\(theme.rawValue)",
                type: .theme,
                name: theme.displayName,
                description: LocalizedStrings.current.themeDescription(theme),
                price: theme.price,
                icon: theme.icon,
                isPremium: true,
                theme: theme
            ))
        }

        // Particle effects
        for effect in ParticleEffect.allCases {
            items.append(ShopItem(
                id: "effect_\(effect.rawValue)",
                type: .particleEffect,
                name: effect.rawValue,
                description: LocalizedStrings.current.particleEffectDescription(effect),
                price: effect.price,
                icon: effect.icon,
                isPremium: false,
                particleEffect: effect
            ))
        }

        // Board frames (only paid ones in shop)
        for frame in BoardFrame.allCases.filter({ !$0.isFree }) {
            items.append(ShopItem(
                id: "frame_\(frame.rawValue)",
                type: .boardFrame,
                name: frame.rawValue,
                description: LocalizedStrings.current.boardFrameDescription(frame),
                price: frame.price,
                icon: frame.icon,
                isPremium: false,
                frameStyle: frame
            ))
        }

        // Background animations (only paid ones in shop)
        for animation in BackgroundAnimation.allCases.filter({ !$0.isFree }) {
            items.append(ShopItem(
                id: "animation_\(animation.rawValue)",
                type: .backgroundAnimation,
                name: LocalizedStrings.current.backgroundAnimationName(animation),
                description: LocalizedStrings.current.backgroundAnimationDescription(animation),
                price: animation.price,
                icon: animation.icon,
                isPremium: false,
                backgroundAnimation: animation
            ))
        }

        return items
    }
}
