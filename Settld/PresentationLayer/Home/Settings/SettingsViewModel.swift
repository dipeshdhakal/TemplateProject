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
    
    @Published var biometricEnabled: Bool = UserDefaults.biometricEnabled
    @Published var errorMessage: String?
    @Published var dummyUserName = ""
    @Published var dummyEmail = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {

        setDummyValues()
        
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
