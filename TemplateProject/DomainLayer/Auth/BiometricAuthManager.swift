//
//  BiometricAuthManager.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import LocalAuthentication
import UIKit

class BiometricAuthManager {
    
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
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate using Face ID or Touch ID") { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func showBiometricsSettingsAlert(_ controller: UIViewController) {
        let alertController = UIAlertController(
            title: "Enable Face ID/Touch ID",
            message: "To use biometric authentication, you need to enable Face ID/Touch ID for this app in your device settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
