//
//  SettingsViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    enum Language: String, CaseIterable, Identifiable {
        case English
        case Arabic
        case Chinese
        
        var id: String { self.rawValue }
    }
    
    @Published var languages = Language.allCases
    @Published var selectedLanguage: Language = Language.English
    @Published var darkMode: Bool
    @Published var biometricUnlock: Bool
    
    @Published var dummyUserName = ""
    @Published var dummyEmail = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        darkMode = AppSettings.shared.currentTheme == .dark
        biometricUnlock = AppSettings.shared.biometricLock
        setDummyValues()
        $darkMode
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { darkMode in
                self.toggleTmeme(darkMode: darkMode)
            }
            .store(in: &cancellables)
        
        $biometricUnlock
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { biometricUnlock in
                if biometricUnlock {
                    self.setUpBiometric()
                } else {
                    AppSettings.shared.biometricLock = false
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
        BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
            if success {
                AppSettings.shared.appUnlocked = true
                AppSettings.shared.biometricLock = true
            } else {
                self.biometricUnlock = false
            }
        }
    }
}
