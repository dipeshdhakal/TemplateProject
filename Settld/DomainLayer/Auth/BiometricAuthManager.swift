//
//  BiometricAuthManager.swift
//  Settld
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import LocalAuthentication
import UIKit

actor BiometricAuthManager {
    
    static let shared = BiometricAuthManager()
    
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
        await withCheckedContinuation { continuation in
            let context = LAContext()
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate using Face ID or Touch ID") { success, error in
                continuation.resume(returning: (success, error))
            }
        }
    }
}
