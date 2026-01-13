//
//  SamoTetrisApp.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

@main
struct SamoTetrisApp: App {
    init() {
        // Start background music when app launches
        AudioManager.shared.startBackgroundMusic()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Root view that manages persistent background animation for main menu
struct RootView: View {
    @ObservedObject private var shopManager = ShopManager.shared
    @State private var backgroundID = UUID()

    var body: some View {
        ZStack {
            // Background gradient - always present
            LinearGradient(
                colors: [
                    Color.vikingBackground,
                    Color(red: 0.08, green: 0.05, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Background animation - persistent across main menu screens
            Group {
                switch shopManager.currentBackgroundAnimation {
                case .tetromino:
                    FallingTetrominoBackground()
                case .bubbles:
                    BubblesBackground()
                case .particles:
                    ParticlesBackground()
                }
            }
            .ignoresSafeArea()
            .id(backgroundID)

            // Main menu content
            MainMenuView()
        }
        .onChange(of: shopManager.currentBackgroundAnimation) { _ in
            // Only regenerate background when user changes it in shop
            backgroundID = UUID()
        }
    }
}
