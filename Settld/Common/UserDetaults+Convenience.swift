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
        static let CurrentVersion = "CurrentVersion"
        static let UserLoggedIn = "UserLoggedIn"
        static let UserOnboarded = "UserOnboarded"
    }

    class var biometricEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.BiometricEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.BiometricEnabled)
        }
    }
    
    class var currentVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.CurrentVersion)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.CurrentVersion)
        }
    }
    
    class var userLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.UserLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.UserLoggedIn)
        }
    }
    
    class var userOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.UserOnboarded)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.UserOnboarded)
        }
    }

}
