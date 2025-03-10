//
//  SettingsViewModel.swift
//  Settld
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import Combine

@MainActor
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
                return [.biometricLock]
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
            }
        }
    }
    
    @Published var biometricEnabled: Bool = UserDefaults.biometricEnabled
    @Published var errorMessage: String?
    @Published var sections: [SettingsSection] = [.links, .preferences, .settings]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        #if DEBUG
        sections.append(.debug)
        #endif
        
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
