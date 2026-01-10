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
            MainMenuView()
        }
    }
}
