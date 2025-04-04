//
//  AppRootViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI
import Combine

@MainActor
class AppRootViewModel: ObservableObject {
    
    @Published var startupCompleted = false
    @Published var shouldForceUpgrade = false
    
    init() {
        Task { @MainActor in
            await completeStartup()
        }
    }
    
    func completeStartup() async {
        await runMigration()
        startupCompleted = true
    }
    
    func runMigration() async {
        UserDefaults.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func forceUpgradeApp() {
        shouldForceUpgrade = true
    }
    
}
