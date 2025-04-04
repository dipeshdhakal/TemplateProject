//
//  PinnedCertificatesEvaluator.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 10/3/2025.
//

import Foundation
import Security

actor SSLPinningManager {
    func validate(challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        if isDebug {
            return (.performDefaultHandling, nil)
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Get the server's certificate
        var serverCertificateData: Data?
        
        if let certs = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate], let firstCert = certs.first {
            serverCertificateData = SecCertificateCopyData(firstCert) as Data
        }

        guard let serverCertData = serverCertificateData else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Load the pinned certificate
        guard let localCertPath = Bundle.main.path(forResource: "pinned_cert", ofType: "cer"),
              let localCertData = try? Data(contentsOf: URL(fileURLWithPath: localCertPath)) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Compare certificates
        if serverCertData == localCertData {
            return (.useCredential, URLCredential(trust: serverTrust))
        } else {
            return (.cancelAuthenticationChallenge, nil)
        }
    }
}

final class SSLPinningDelegate: NSObject, URLSessionDelegate {
    private let pinningManager = SSLPinningManager()
    
    nonisolated func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @Sendable @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        Task {
            let result = await pinningManager.validate(challenge: challenge)
            completionHandler(result.0, result.1)
        }
    }
}
