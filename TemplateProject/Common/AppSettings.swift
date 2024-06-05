//
//  AppSettings.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import SwiftUI

class AppSettings: ObservableObject {

    static let shared = AppSettings()
    
    @AppStorage("current_theme") var currentTheme: Theme = .system
    @AppStorage("biometricSwitchState") var biometricLock: Bool = false
    @Published var appUnlocked: Bool = false
}
