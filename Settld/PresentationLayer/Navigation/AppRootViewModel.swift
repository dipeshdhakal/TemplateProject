//
//  AppRootViewModel.swift
//  Settld
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI
import Combine

@MainActor
class AppRootViewModel: ObservableObject {
    
    @Published var startupCompleted = false
    
    init() {
        Task { @MainActor in
            await completeStartup()
        }
    }
    
    func completeStartup() async {
        await runMigration()
        #if DEBUG
//            UserDefaults.userOnboarded = false
        #endif
        startupCompleted = true
    }
    
    func runMigration() async {
        UserDefaults.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
}
