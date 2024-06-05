//
//  PKDataManager.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import Foundation

class PKDataManager {
    
    static var shared = PKDataManager()
    
    var userIdData: Data?
    var userId: String?
    var username: String?
    var challenge: Data?
    var attestation: String?
    var assertion: String?
    
    init() {
        getChallenge()
    }
    
    // Fake server
    func getChallenge() {
        let buffer = [UInt8](repeating: 0, count: 32)
        challenge = Data(buffer)
        userId = "44"
        userIdData = userId?.data(using: .utf8)
        username = "Dipesh EPC"
    }
}

extension Data {
    func base64URLEncode() -> String {
        let base64 = self.base64EncodedString()
        let base64URL = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64URL
    }
}
