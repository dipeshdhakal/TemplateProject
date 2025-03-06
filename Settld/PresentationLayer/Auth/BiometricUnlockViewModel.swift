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
        Task {
            let type = await BiometricAuthManager.shared.getBiometricType
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
    }
    
    func attemptBiometricAuthentication() async -> Bool {
        
        guard !biometricShown else {
            return true
        }
        
        biometricShown = true
        
        if await BiometricAuthManager.shared.canUseBiometricAuthentication {
            let (success, error) = await BiometricAuthManager.shared.authenticateWithBiometrics()
            if !success {
                alertDetails = AlertDetails(title: "Biometric Authentication Failed", message: error?.localizedDescription ?? "Biometric authentication failed. Please try again.")
                isShowingAlert = true
            }
            return success
        } else {
            alertDetails = AlertDetails(title: "Biometric Authentication Failed")
            isShowingAlert = true
            return false
        }
    }
}
