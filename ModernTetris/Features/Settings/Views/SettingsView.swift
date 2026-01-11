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
    @ObservedObject private var audioManager = AudioManager.shared
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("ghostPieceEnabled") private var ghostPieceEnabled = true
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    @State private var showLanguagePicker = false

    // Track previous values to detect changes
    @State private var previousSoundEnabled: Bool?
    @State private var previousMusicEnabled: Bool?
    @State private var previousHapticEnabled: Bool?
    @State private var previousGhostPieceEnabled: Bool?

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

                        // Audio settings
                        settingsSection(title: LocalizedStrings.current.audio) {
                            settingToggle(
                                icon: "speaker.wave.3.fill",
                                title: LocalizedStrings.current.soundEffects,
                                isOn: $audioManager.soundEnabled
                            )

                            settingToggle(
                                icon: "music.note",
                                title: LocalizedStrings.current.music,
                                isOn: $audioManager.musicEnabled
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
                    Button(action: {
                        audioManager.buttonClick()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.vikingGold)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showLanguagePicker) {
            pickerView(
                title: LocalizedStrings.current.languageLabel,
                items: AppLanguage.allCases.map { ($0.rawValue, $0.code) },
                selectedValue: $selectedLanguage
            )
        }
        .onAppear {
            // Initialize previous values
            previousSoundEnabled = audioManager.soundEnabled
            previousMusicEnabled = audioManager.musicEnabled
            previousHapticEnabled = hapticEnabled
            previousGhostPieceEnabled = ghostPieceEnabled
        }
        .onChange(of: audioManager.soundEnabled) { newValue in
            if let previous = previousSoundEnabled, previous != newValue {
                audioManager.buttonClick()
            }
            previousSoundEnabled = newValue
        }
        .onChange(of: audioManager.musicEnabled) { newValue in
            if let previous = previousMusicEnabled, previous != newValue {
                audioManager.buttonClick()
            }
            previousMusicEnabled = newValue
        }
        .onChange(of: hapticEnabled) { newValue in
            if let previous = previousHapticEnabled, previous != newValue {
                audioManager.buttonClick()
            }
            previousHapticEnabled = newValue
        }
        .onChange(of: ghostPieceEnabled) { newValue in
            if let previous = previousGhostPieceEnabled, previous != newValue {
                audioManager.buttonClick()
            }
            previousGhostPieceEnabled = newValue
        }
    }

    var currentLanguageName: String {
        AppLanguage.allCases.first { $0.code == selectedLanguage }?.rawValue ?? "English"
    }

    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
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
                .font(.system(size: 18))
                .foregroundColor(.primaryText)

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
                .font(.system(size: 18))
                .foregroundColor(.primaryText)

            Spacer()

            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func settingSelector(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            audioManager.buttonClick()
            action()
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.vikingAccent)
                    .frame(width: 28)

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primaryText)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
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
                                audioManager.buttonClick()
                                selectedValue.wrappedValue = item.1
                            }) {
                                HStack {
                                    Text(item.0)
                                        .font(.system(size: 18, weight: selectedValue.wrappedValue == item.1 ? .semibold : .regular))
                                        .foregroundColor(selectedValue.wrappedValue == item.1 ? .primaryText : .secondaryText)

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
                    Button(action: {
                        audioManager.buttonClick()
                        showLanguagePicker = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.vikingGold)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SettingsView()
}
