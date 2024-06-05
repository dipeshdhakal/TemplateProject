//
//  BiometricUnlockViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import Foundation

class BiometricUnlockViewModel: ObservableObject {
    
    var systemImageName: String?
    @Published var errorMessage: String?
    
    init() {
        getBiometricType()
    }
    
    func getBiometricType() {
        let type = BiometricAuthManager.shared.getBiometricType
        switch type {
        case .opticID:
            systemImageName = "opticid"
        case .touchID:
            systemImageName = "touchid"
        case .faceID:
            systemImageName = "faceid"
        default:
            break
        }
    }
    
    func attemptBiometricAuthentication() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication {
            BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
                if success {
                    AppSettings.shared.appUnlocked = true
                } else {
                    self.errorMessage = error?.localizedDescription
                }
            }
        } else {
            errorMessage = "Biometric authentication is not available on this device."
        }
    }
}
