//
//  SettingsView.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Settings screen
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("musicEnabled") private var musicEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("ghostPieceEnabled") private var ghostPieceEnabled = true
    @AppStorage("selectedTheme") private var selectedTheme = "Viking"
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    @State private var showLanguagePicker = false
    @State private var showThemePicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.vikingBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Language settings
                        settingsSection(title: LocalizedStrings.current.languageLabel) {
                            settingSelector(
                                icon: "globe",
                                title: currentLanguageName,
                                action: { showLanguagePicker = true }
                            )
                        }

                        // Theme settings
                        settingsSection(title: LocalizedStrings.current.theme) {
                            settingSelector(
                                icon: "paintbrush.fill",
                                title: selectedTheme,
                                action: { showThemePicker = true }
                            )
                        }

                        // Audio settings
                        settingsSection(title: LocalizedStrings.current.audio) {
                            settingToggle(
                                icon: "speaker.wave.3.fill",
                                title: LocalizedStrings.current.soundEffects,
                                isOn: $soundEnabled
                            )

                            settingToggle(
                                icon: "music.note",
                                title: LocalizedStrings.current.music,
                                isOn: $musicEnabled
                            )
                        }

                        // Gameplay settings
                        settingsSection(title: LocalizedStrings.current.gameplay) {
                            settingToggle(
                                icon: "hand.raised.fill",
                                title: LocalizedStrings.current.hapticFeedback,
                                isOn: $hapticEnabled
                            )

                            settingToggle(
                                icon: "square.dashed",
                                title: LocalizedStrings.current.ghostPiece,
                                isOn: $ghostPieceEnabled
                            )
                        }

                        // About section
                        settingsSection(title: LocalizedStrings.current.about) {
                            settingRow(icon: "info.circle.fill", title: LocalizedStrings.current.versionLabel, value: "1.0.0")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(LocalizedStrings.current.settings)
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
        .sheet(isPresented: $showLanguagePicker) {
            pickerView(
                title: LocalizedStrings.current.languageLabel,
                items: AppLanguage.allCases.map { ($0.rawValue, $0.code) },
                selectedValue: $selectedLanguage
            )
        }
        .sheet(isPresented: $showThemePicker) {
            pickerView(
                title: LocalizedStrings.current.theme,
                items: GameTheme.allCases.map { ($0.displayName, $0.rawValue) },
                selectedValue: $selectedTheme
            )
        }
    }

    var currentLanguageName: String {
        AppLanguage.allCases.first { $0.code == selectedLanguage }?.rawValue ?? "English"
    }

    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.vikingGold.opacity(0.8))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vikingWood.opacity(0.4))
            )
        }
    }

    private func settingToggle(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.vikingAccent)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: isOn)
                .tint(.vikingGold)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func settingRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.vikingAccent)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Spacer()

            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func settingSelector(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.vikingAccent)
                    .frame(width: 28)

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }

    private func pickerView(title: String, items: [(String, String)], selectedValue: Binding<String>) -> some View {
        NavigationView {
            ZStack {
                Color.vikingBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(items, id: \.1) { item in
                            Button(action: {
                                selectedValue.wrappedValue = item.1
                            }) {
                                HStack {
                                    Text(item.0)
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)

                                    Spacer()

                                    if selectedValue.wrappedValue == item.1 {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.vikingGold)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.vikingWood.opacity(selectedValue.wrappedValue == item.1 ? 0.6 : 0.3))
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.current.done) {
                        showLanguagePicker = false
                        showThemePicker = false
                    }
                    .foregroundColor(.vikingGold)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
