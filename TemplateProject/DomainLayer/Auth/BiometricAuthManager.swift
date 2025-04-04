//
//  BiometricAuthManager.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import LocalAuthentication
import UIKit

class BiometricAuthManager {
    
    nonisolated(unsafe) static let shared = BiometricAuthManager()
    
    private init() {}
    
    var canUseBiometricAuthentication: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    var getBiometricType: LABiometryType {
        let context = LAContext()
        return context.biometryType
    }
    
    func authenticateWithBiometrics() async -> (Bool, Error?) {
        let context = LAContext()
        do {
            try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: String(localized: "Biometric.Auth.Message", table: "Shared"))
            return (true, nil)
        } catch {
            return (false, error)
        }
    }
}
