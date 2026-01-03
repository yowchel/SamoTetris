//
//  TestViewModel.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation
import Combine
import SwiftUI

// Простейший тест ObservableObject
class TestViewModel: ObservableObject {
    @Published var count: Int = 0

    func increment() {
        count += 1
    }
}
