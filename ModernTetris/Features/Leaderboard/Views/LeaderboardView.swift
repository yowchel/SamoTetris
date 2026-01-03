//
//  LeaderboardView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Leaderboard screen
struct LeaderboardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0
    @AppStorage("highScore") private var highScore = 0
    @AppStorage("totalGames") private var totalGames = 0
    @AppStorage("totalLines") private var totalLines = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.vikingBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Tabs
                    Picker("Stats", selection: $selectedTab) {
                        Text(LocalizedStrings.current.personal).tag(0)
                        Text(LocalizedStrings.current.global).tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    if selectedTab == 0 {
                        personalStatsView
                    } else {
                        globalLeaderboardView
                    }
                }
            }
            .navigationTitle(LocalizedStrings.current.leaderboard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.current.done) {
                        dismiss()
                    }
                    .foregroundColor(.vikingGold)
                }
            }
        }
    }

    private var personalStatsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // High score card
                statCard(
                    icon: "trophy.fill",
                    title: LocalizedStrings.current.highScore,
                    value: "\(highScore)",
                    gradient: [.vikingGold, Color(red: 0.7, green: 0.55, blue: 0.2)]
                )

                // Other stats
                HStack(spacing: 16) {
                    smallStatCard(
                        icon: "gamecontroller.fill",
                        title: LocalizedStrings.current.games,
                        value: "\(totalGames)"
                    )

                    smallStatCard(
                        icon: "chart.bar.fill",
                        title: LocalizedStrings.current.lines,
                        value: "\(totalLines)"
                    )
                }

                // Achievements section
                achievementsSection
            }
            .padding()
        }
    }

    private var globalLeaderboardView: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Image(systemName: "network.slash")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))

                Text(LocalizedStrings.current.comingSoon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(LocalizedStrings.current.globalLeaderboardMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStrings.current.achievements)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.vikingGold.opacity(0.8))
                .padding(.leading, 4)

            VStack(spacing: 12) {
                achievementRow(
                    icon: "star.fill",
                    title: LocalizedStrings.current.firstVictory,
                    description: LocalizedStrings.current.firstVictoryDesc,
                    unlocked: totalGames > 0
                )

                achievementRow(
                    icon: "flame.fill",
                    title: LocalizedStrings.current.lineMaster,
                    description: LocalizedStrings.current.lineMasterDesc,
                    unlocked: totalLines >= 100
                )

                achievementRow(
                    icon: "bolt.fill",
                    title: LocalizedStrings.current.speedDemon,
                    description: LocalizedStrings.current.speedDemonDesc,
                    unlocked: highScore >= 1000
                )
            }
        }
    }

    private func statCard(icon: String, title: String, value: String, gradient: [Color]) -> some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))

                Text(value)
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: gradient[0].opacity(0.4), radius: 10)
    }

    private func smallStatCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.vikingAccent)

            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vikingWood.opacity(0.4))
        )
    }

    private func achievementRow(icon: String, title: String, description: String, unlocked: Bool) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(unlocked ? .vikingGold : .white.opacity(0.3))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(unlocked ? Color.vikingGold.opacity(0.2) : Color.white.opacity(0.05))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(unlocked ? .white : .white.opacity(0.5))

                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vikingWood.opacity(unlocked ? 0.4 : 0.2))
        )
    }
}

#Preview {
    LeaderboardView()
}
