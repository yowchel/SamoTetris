//
//  MainMenuView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Main menu screen
struct MainMenuView: View {
    @State private var showSettings = false
    @State private var showLeaderboard = false
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

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)

                // Title
                Text(LocalizedStrings.current.appTitle)
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.vikingGold)
                    .shadow(color: .vikingGold.opacity(0.5), radius: 15)

                Spacer()

                // Menu buttons
                VStack(spacing: 16) {
                    menuButton(
                        icon: "play.fill",
                        title: LocalizedStrings.current.play,
                        gradient: [.vikingGold, Color(red: 0.7, green: 0.55, blue: 0.2)]
                    ) {
                        showGame = true
                    }

                    menuButton(
                        icon: "chart.bar.fill",
                        title: LocalizedStrings.current.leaderboard,
                        gradient: [.vikingAccent, .vikingAccent.opacity(0.7)]
                    ) {
                        showLeaderboard = true
                    }

                    menuButton(
                        icon: "gearshape.fill",
                        title: LocalizedStrings.current.settings,
                        gradient: [.buttonGray, .buttonGray.opacity(0.7)]
                    ) {
                        showSettings = true
                    }
                }

                Spacer()

                // Version info
                Text(LocalizedStrings.current.version)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))
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
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
        }
    }

    private func menuButton(icon: String, title: String, gradient: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .frame(maxWidth: 350, minHeight: 60, maxHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: gradient[0].opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    MainMenuView()
}
