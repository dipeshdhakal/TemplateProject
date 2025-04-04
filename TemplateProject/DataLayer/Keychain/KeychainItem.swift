//
//  KeychainItem.swift
//  KeychainWrapper
//
//  Created by Mars on 2019/9/22.
//  Copyright © 2019 Mars. All rights reserved.
//

import Foundation

// https://github.com/jrendel/SwiftKeychainWrapper

/**
 class Demo {
 @KeychainStoreString(key: "demo.key") var value: String?
 }
 */

@propertyWrapper
struct KeychainStoreString {
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: String? {
        get {
            KeychainWrapper.default.string(forKey: key)
        }
        
        set {
            guard let v = newValue else { return }
            
            KeychainWrapper.default.set(v, forKey: key)
        }
    }
    
    var projectedValue: KeychainWrapper {
        get {
            return KeychainWrapper.default
        }
    }
}

@propertyWrapper
struct KeychainStoreNumber<T> where T: Numeric, T: Codable {
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            KeychainWrapper.default.object(of: T.self, forKey: key)
        }
        
        set {
            guard let v = newValue else { return }
            
            KeychainWrapper.default.set(v, forKey: key)
        }
    }
    
    var projectedValue: KeychainWrapper {
        get {
            return KeychainWrapper.default
        }
    }
}

@propertyWrapper
struct KeychainStoreObject<T> where T: Codable {
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            KeychainWrapper.default.object(of: T.self, forKey: key)
        }
        
        set {
            guard let v = newValue else { return }
            
            KeychainWrapper.default.set(v, forKey: key)
        }
    }
    
    public var projectedValue: KeychainWrapper {
        get {
            return KeychainWrapper.default
        }
    }
}

//@propertyWrapper
//public struct KeychainStore<T> where T: Codable {
//  public let key: String
//  public let `default` = KeychainWrapper.default
//
//  public init(key: String) {
//    self.key = key
//  }
//
//  public init(wrappedValue: T, key: String) {
//    self.init(key: key)
//    self.wrappedValue = wrappedValue
//  }
//
//  public var wrappedValue: T {
//    get {
//      KeychainWrapper.default.object(of: T.self, forKey: key)!
//    }
//
//    set {
//      KeychainWrapper.default.set(newValue, forKey: key)
//    }
//  }
//
//  public var projectedValue: KeychainWrapper {
//    get {
//      return self.default
//    }
//  }
//}
