//
//  SettingsViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    enum SettingsSection: CaseIterable {
        case links
        case preferences
        case settings
        case debug
        
        var rows: [SettingsRow] {
            switch self {
            case .links:
                return [.appURL]
            case .preferences:
                return [.biometricLock, .theme]
            case .settings:
                return [.signOut]
            case .debug:
                return [.debugSwitches]
            }
        }
        
        var title: String {
            switch self {
            case .links:
                return "LINKS"
            case .preferences:
                return "PREFRENCES"
            case .settings:
                return "SETTINGS"
            case .debug:
                return "DEBUG"
            }
        }
    }
    
    enum SettingsRow {
        case appURL
        case biometricLock
        case signOut
        case debugSwitches
        case theme
        
        var title: String {
            switch self {
            case .appURL:
                return "App URL"
            case .biometricLock:
                return "Biometric Lock"
            case .signOut:
                return "Sign out"
            case .debugSwitches:
                return "Debug Switches"
            case .theme:
                return "Theme"
            }
        }
    }
    
    enum Language: String, CaseIterable, Identifiable {
        case English
        case Arabic
        case Chinese
        
        var id: String { self.rawValue }
    }
    
    @Published var darkMode: Bool
    @Published var dummyUserName = ""
    @Published var dummyEmail = ""
    
    @Published var biometricEnabled: Bool = UserDefaults.biometricEnabled
    @Published var errorMessage: String?
    @Published var sections: [SettingsSection] = [.links, .preferences, .settings]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        darkMode = AppSettings.shared.currentTheme == .dark
        setDummyValues()
        $darkMode
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { darkMode in
                self.toggleTmeme(darkMode: darkMode)
            }
            .store(in: &cancellables)
        
        if isDebug {
            sections.append(.debug)
        }
        
        $biometricEnabled
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { biometricUnlock in
                if biometricUnlock {
                    self.setUpBiometric()
                } else {
                    UserDefaults.biometricEnabled = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func setDummyValues() {
        dummyUserName = "Dipesh Dhakal"
        dummyEmail = "dipesh.dhakal4040@gmail.com"
    }
    
    func toggleTmeme(darkMode: Bool) {
        AppSettings.shared.currentTheme = darkMode ? .dark : .light
    }
    
    func setUpBiometric() {
        Task {
            let (success, error) = await BiometricAuthManager.shared.authenticateWithBiometrics()
            if success {
                UserDefaults.biometricEnabled = true
            } else {
                errorMessage = error?.localizedDescription
                biometricEnabled = false
            }
        }
    }
    
}
