//
//  MainMenuView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Main menu screen
struct MainMenuView: View {
    @ObservedObject private var shopManager = ShopManager.shared
    @State private var showSettings = false
    @State private var showLeaderboard = false
    @State private var showShop = false
    @State private var showGame = false
    @State private var refreshID = UUID()

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.vikingBackground,
                    Color(red: 0.08, green: 0.05, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Background animation based on selected type
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

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)

                // Title
                Text(LocalizedStrings.current.appTitle)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.titleText)
                    .shadow(color: .titleText.opacity(0.5), radius: 15)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Spacer()

                // Menu buttons
                VStack(spacing: 16) {
                    menuButton(
                        icon: "play.fill",
                        title: LocalizedStrings.current.play,
                        gradient: [.playButtonColor, .playButtonColor.opacity(0.7)],
                        textColor: .playButtonTextColor
                    ) {
                        showGame = true
                    }

                    menuButton(
                        icon: "cart.fill",
                        title: LocalizedStrings.current.shop,
                        gradient: [.shopButtonColor, .shopButtonColor.opacity(0.7)],
                        textColor: .shopButtonTextColor
                    ) {
                        showShop = true
                    }

                    menuButton(
                        icon: "chart.bar.fill",
                        title: LocalizedStrings.current.leaderboard,
                        gradient: [.leaderboardButtonColor, .leaderboardButtonColor.opacity(0.7)],
                        textColor: .leaderboardButtonTextColor
                    ) {
                        showLeaderboard = true
                    }

                    menuButton(
                        icon: "gearshape.fill",
                        title: LocalizedStrings.current.settings,
                        gradient: [.settingsButtonColor, .settingsButtonColor.opacity(0.7)],
                        textColor: .settingsButtonTextColor
                    ) {
                        showSettings = true
                    }
                }

                Spacer()

                // Version info
                Text(LocalizedStrings.current.version)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondaryText.opacity(0.75))
                    .padding(.bottom, 12)
            }
            .padding()
        }
        .id(refreshID)
        .fullScreenCover(isPresented: $showGame) {
            GameView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onChange(of: showSettings) { isShowing in
            if !isShowing {
                // Refresh view when settings closed
                refreshID = UUID()
            }
        }
        .onChange(of: showShop) { isShowing in
            if !isShowing {
                // Refresh view when shop closed (theme might have changed)
                refreshID = UUID()
            }
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
        }
        .sheet(isPresented: $showShop) {
            ShopView()
        }
    }

    private func menuButton(icon: String, title: String, gradient: [Color], textColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            AudioManager.shared.buttonClick()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 32)

                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Spacer()
                    .frame(width: 32)
            }
            .foregroundColor(textColor)
            .padding(.horizontal, 20)
            .frame(width: 350, height: 60)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: gradient[0].opacity(0.4), radius: 20, x: 0, y: 10)
        }
    }
}

#Preview {
    MainMenuView()
}
