//
//  UserDetaults+Convenience.swift
//  Settld
//
//  Created by Dipesh Dhakal on 6/3/2025.
//
import Foundation

extension UserDefaults {

    private enum Keys {
        static let BiometricEnabled = "BiometricEnabled"
    }

    class var biometricEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.BiometricEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.BiometricEnabled)
        }
    }

}
