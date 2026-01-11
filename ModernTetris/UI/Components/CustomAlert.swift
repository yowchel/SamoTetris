//
//  CustomAlert.swift
//  SamoTetris
//
//  Created on 2026-01-11
//

import SwiftUI

/// Custom themed alert overlay
struct CustomAlert: View {
    let message: String
    let onDismiss: () -> Void
    @ObservedObject var shopManager = ShopManager.shared
    @ObservedObject var audioManager = AudioManager.shared

    var body: some View {
        ZStack {
            // Dark overlay background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    audioManager.buttonClick()
                    onDismiss()
                }

            // Alert card
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(currentTheme.primaryAccent.opacity(0.2))
                        .frame(width: 80, height: 80)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(currentTheme.primaryAccent)
                }
                .padding(.top, 10)

                // Message
                Text(message)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(currentTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                // OK button
                Button(action: {
                    audioManager.buttonClick()
                    onDismiss()
                }) {
                    Text("OK")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(currentTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(currentTheme.primaryAccent.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(currentTheme.primaryAccent.opacity(0.5), lineWidth: 2)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(currentTheme.wood)
                    .shadow(color: currentTheme.primaryAccent.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(currentTheme.primaryAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }

    private var currentTheme: GameTheme {
        return shopManager.currentTheme
    }
}

/// Alert modifier for easy use
struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                CustomAlert(message: message) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPresented = false
                    }
                }
                .zIndex(999)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(CustomAlertModifier(isPresented: isPresented, message: message))
    }
}
