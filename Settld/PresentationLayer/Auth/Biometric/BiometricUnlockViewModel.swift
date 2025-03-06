//
//  BiometricUnlockViewModel.swift
//  Settld
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import Foundation

@MainActor
class BiometricUnlockViewModel: ObservableObject, AlertPresentable {
    
    var systemImageName: String?
    @Published var errorMessage: String?
    @Published var isShowingAlert: Bool = false
    @Published var alertDetails: AlertDetails = AlertDetails(title: "")
    private var biometricShown = false
    
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

    func attemptBiometricAuthentication() async -> Bool {
        if BiometricAuthManager.shared.canUseBiometricAuthentication {
            let (success, error) = await BiometricAuthManager.shared.authenticateWithBiometrics()
            if !success {
                self.alertDetails = AlertDetails(title: String(localized: "Biometric.Failed.Title", table: "Shared"), message: error?.localizedDescription ?? String(localized: "Alert.Message.TryAgain", table: "Shared"))
                self.isShowingAlert = true
            } else {
                return true
            }
        } else {
            alertDetails = AlertDetails(title: String(localized: "Biometric.Failed.Title", table: "Shared"))
            isShowingAlert = true
        }
        return false
    }
}
