//
//  ShopView.swift
//  SamoTetris
//
//  Created on 2026-01-04
//

import SwiftUI

/// Shop screen for purchasing items with coins
struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var currencyManager = CurrencyManager.shared
    @ObservedObject var shopManager = ShopManager.shared
    @ObservedObject var audioManager = AudioManager.shared

    @State private var selectedCategory = 0
    @State private var showPurchaseAlert = false
    @State private var purchaseMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.vikingBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Coins balance header
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.vikingGold)
                                .frame(width: 40, height: 40)

                            Text("S")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.playButtonTextColor)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(LocalizedStrings.current.coins)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondaryText)
                            Text("\(currencyManager.coins)")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.vikingGold)
                        }

                        Spacer()

                        // Dev: Add test coins button
                        Button(action: {
                            audioManager.buttonClick()
                            currencyManager.addTestCoins()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("TEST")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.playButtonTextColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.vikingGold)
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.vikingWood.opacity(0.6))
                            .shadow(color: Color.vikingGold.opacity(0.2), radius: 8)
                    )
                    .padding()

                    // Category tabs
                    HStack(spacing: 0) {
                        categoryTab(title: LocalizedStrings.current.themes, index: 0)
                        categoryTab(title: LocalizedStrings.current.particleEffects, index: 1)
                        categoryTab(title: LocalizedStrings.current.boardFrames, index: 2)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                    // Items grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            if selectedCategory == 0 {
                                ForEach(GameTheme.allCases, id: \.self) { theme in
                                    themeCard(theme)
                                }
                            } else if selectedCategory == 1 {
                                ForEach(ParticleEffect.allCases, id: \.self) { effect in
                                    particleEffectCard(effect)
                                }
                            } else {
                                ForEach(BoardFrame.allCases, id: \.self) { frame in
                                    boardFrameCard(frame)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(LocalizedStrings.current.shop)
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
        .alert(purchaseMessage, isPresented: $showPurchaseAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    // MARK: - Category Tab

    private func categoryTab(title: String, index: Int) -> some View {
        Button(action: {
            audioManager.buttonClick()
            selectedCategory = index
        }) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(selectedCategory == index ? .primaryText : .secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedCategory == index ? Color.vikingGold.opacity(0.3) : Color.clear)
                )
        }
    }

    // MARK: - Particle Effect Card

    private func particleEffectCard(_ effect: ParticleEffect) -> some View {
        let isUnlocked = shopManager.isUnlocked(effect)
        let isEquipped = shopManager.currentParticleEffect == effect

        return VStack(spacing: 10) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.vikingGold.opacity(0.2) : Color.vikingWood.opacity(0.3))
                    .frame(width: 70, height: 70)

                Image(systemName: effect.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isUnlocked ? .vikingGold : .secondaryText)
            }

            // Name
            Text(effect.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primaryText)
                .lineLimit(1)
                .frame(height: 20)

            // Description
            Text(LocalizedStrings.current.particleEffectDescription(effect))
                .font(.system(size: 11))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(height: 36)

            Spacer()

            // Button
            Group {
                if isEquipped {
                    Button(action: {
                        audioManager.buttonClick()
                        shopManager.selectParticleEffect(nil)  // Unequip effect
                    }) {
                        Text(LocalizedStrings.current.remove)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.dangerColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.dangerColor.opacity(0.2))
                            )
                    }
                } else if isUnlocked {
                    Button(action: {
                        audioManager.buttonClick()
                        shopManager.selectParticleEffect(effect)
                    }) {
                        Text(LocalizedStrings.current.equip)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.playButtonTextColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.playButtonColor)
                            )
                    }
                } else {
                    Button(action: {
                        audioManager.buttonClick()
                        purchaseParticleEffect(effect)
                    }) {
                        HStack(spacing: 5) {
                            ZStack {
                                Circle()
                                    .fill(Color.playButtonTextColor.opacity(0.3))
                                    .frame(width: 18, height: 18)
                                Text("S")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.vikingGold)
                            }
                            Text("\(effect.price)")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.playButtonTextColor)
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.vikingGold)
                        )
                    }
                }
            }
        }
        .frame(height: 240)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vikingWood.opacity(isUnlocked ? 0.6 : 0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEquipped ? Color.successColor : Color.vikingGold.opacity(isUnlocked ? 0.4 : 0.2), lineWidth: 2)
                )
        )
    }

    // MARK: - Board Frame Card

    private func boardFrameCard(_ frame: BoardFrame) -> some View {
        let isUnlocked = shopManager.isUnlocked(frame)
        let isEquipped = shopManager.currentBoardFrame == frame

        return VStack(spacing: 10) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.vikingAccent.opacity(0.2) : Color.vikingWood.opacity(0.3))
                    .frame(width: 70, height: 70)

                Image(systemName: frame.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isUnlocked ? .vikingAccent : .secondaryText)
            }

            // Name
            Text(frame.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primaryText)
                .lineLimit(1)
                .frame(height: 20)

            // Description
            Text(LocalizedStrings.current.boardFrameDescription(frame))
                .font(.system(size: 11))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(height: 36)

            Spacer()

            // Button
            Group {
                if isEquipped {
                    Button(action: {
                        audioManager.buttonClick()
                        shopManager.selectBoardFrame(nil)  // Unequip frame
                    }) {
                        Text(LocalizedStrings.current.remove)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.dangerColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.dangerColor.opacity(0.2))
                            )
                    }
                } else if isUnlocked {
                    Button(action: {
                        audioManager.buttonClick()
                        shopManager.selectBoardFrame(frame)
                    }) {
                        Text(LocalizedStrings.current.equip)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.playButtonTextColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.playButtonColor)
                            )
                    }
                } else {
                    Button(action: {
                        audioManager.buttonClick()
                        purchaseBoardFrame(frame)
                    }) {
                        HStack(spacing: 5) {
                            ZStack {
                                Circle()
                                    .fill(Color.playButtonTextColor.opacity(0.3))
                                    .frame(width: 18, height: 18)
                                Text("S")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.vikingGold)
                            }
                            Text("\(frame.price)")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.playButtonTextColor)
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.vikingGold)
                        )
                    }
                }
            }
        }
        .frame(height: 240)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vikingWood.opacity(isUnlocked ? 0.6 : 0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEquipped ? Color.successColor : Color.vikingAccent.opacity(isUnlocked ? 0.4 : 0.2), lineWidth: 2)
                )
        )
    }

    // MARK: - Theme Card

    private func themeCard(_ theme: GameTheme) -> some View {
        let isUnlocked = shopManager.isUnlocked(theme)
        let isEquipped = shopManager.currentTheme == theme

        return VStack(spacing: 10) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? theme.primaryAccent.opacity(0.2) : Color.vikingWood.opacity(0.3))
                    .frame(width: 70, height: 70)

                Image(systemName: theme.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isUnlocked ? theme.primaryAccent : .secondaryText)
            }

            // Name
            Text(theme.displayName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primaryText)
                .lineLimit(1)
                .frame(height: 20)

            // Description
            Text(LocalizedStrings.current.themeDescription(theme))
                .font(.system(size: 11))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(height: 36)

            Spacer()

            // Button
            Group {
                if isEquipped {
                    Text(LocalizedStrings.current.equipped)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.successColor)
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.successColor.opacity(0.2))
                        )
                } else if isUnlocked {
                    Button(action: {
                        audioManager.buttonClick()
                        shopManager.selectTheme(theme)
                    }) {
                        Text(LocalizedStrings.current.equip)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.playButtonTextColor)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.playButtonColor)
                            )
                    }
                } else {
                    Button(action: {
                        audioManager.buttonClick()
                        purchaseTheme(theme)
                    }) {
                        HStack(spacing: 5) {
                            ZStack {
                                Circle()
                                    .fill(Color.playButtonTextColor.opacity(0.3))
                                    .frame(width: 18, height: 18)
                                Text("S")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.vikingGold)
                            }
                            Text("\(theme.price)")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.playButtonTextColor)
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.vikingGold)
                        )
                    }
                }
            }
        }
        .frame(height: 240)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vikingWood.opacity(isUnlocked ? 0.6 : 0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEquipped ? Color.successColor : theme.primaryAccent.opacity(isUnlocked ? 0.4 : 0.2), lineWidth: 2)
                )
        )
    }

    // MARK: - Purchase Actions

    private func purchaseTheme(_ theme: GameTheme) {
        if shopManager.purchaseTheme(theme) {
            purchaseMessage = LocalizedStrings.current.purchased
            showPurchaseAlert = true
        } else {
            purchaseMessage = LocalizedStrings.current.notEnoughCoins
            showPurchaseAlert = true
        }
    }

    private func purchaseParticleEffect(_ effect: ParticleEffect) {
        if shopManager.purchaseParticleEffect(effect) {
            purchaseMessage = LocalizedStrings.current.purchased
            showPurchaseAlert = true
        } else {
            purchaseMessage = LocalizedStrings.current.notEnoughCoins
            showPurchaseAlert = true
        }
    }

    private func purchaseBoardFrame(_ frame: BoardFrame) {
        if shopManager.purchaseBoardFrame(frame) {
            purchaseMessage = LocalizedStrings.current.purchased
            showPurchaseAlert = true
        } else {
            purchaseMessage = LocalizedStrings.current.notEnoughCoins
            showPurchaseAlert = true
        }
    }
}

#Preview {
    ShopView()
}
