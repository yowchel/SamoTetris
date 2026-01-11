//
//  HapticManager.swift
//  SamoTetris
//
//  Created on 2026-01-04
//

import UIKit
import SwiftUI

/// Manages haptic feedback throughout the app
class HapticManager: ObservableObject {
    static let shared = HapticManager()

    @AppStorage("hapticEnabled") private var hapticEnabled = true

    // Haptic generators (reused for performance)
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    private init() {
        // Prepare generators on init for faster response
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }

    // MARK: - Game Actions

    /// Light haptic for piece movement (left/right)
    func pieceMoved() {
        guard hapticEnabled else { return }
        impactLight.impactOccurred()
        impactLight.prepare()
    }

    /// Medium haptic for piece rotation
    func pieceRotated() {
        guard hapticEnabled else { return }
        impactMedium.impactOccurred()
        impactMedium.prepare()
    }

    /// Heavy haptic for piece lock
    func pieceLocked() {
        guard hapticEnabled else { return }
        impactHeavy.impactOccurred()
        impactHeavy.prepare()
    }

    /// Success haptic for line clear
    func lineCleared() {
        guard hapticEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
        notificationGenerator.prepare()
    }

    /// Extra strong haptic for Tetris (4 lines)
    func tetris() {
        guard hapticEnabled else { return }
        // Double impact for emphasis
        impactHeavy.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.impactHeavy.impactOccurred()
            self?.impactHeavy.prepare()
        }
    }

    /// Warning haptic for game over
    func gameOver() {
        guard hapticEnabled else { return }
        notificationGenerator.notificationOccurred(.error)
        notificationGenerator.prepare()
    }

    /// Light haptic for hold piece
    func pieceHeld() {
        guard hapticEnabled else { return }
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare()
    }

    // MARK: - UI Actions

    /// Light selection haptic for button taps
    func buttonTap() {
        guard hapticEnabled else { return }
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare()
    }
}
