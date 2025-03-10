//
//  AuthManager.swift
//  Settld
//
//  Created by Dipesh Dhakal on 7/3/2025.
//

import Foundation

struct Token: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let expiryDate: String?
}

protocol AuthManagable: Sendable {
    func getToken() async throws -> Token
    func fetchValidAuthToken() async throws -> Token
}

protocol TokenDataProvidable: Sendable {
    var tokenString: String? { get }
    var tokenExpiryDate: String? { get }
    func setToken(token: Token) async
}

final class DefaultTokenDataProvider: TokenDataProvidable {
    
    var tokenString: String? {
        KeychainWrapper.default.string(forKey: AuthManager.AccessTokenKey)
    }
    
    var refreshTokenString: String? {
        KeychainWrapper.default.string(forKey: AuthManager.RefreshTokenKey)
    }
    
    var tokenExpiryDate: String? {
        KeychainWrapper.default.string(forKey: AuthManager.AccessTokenExpiryKey)
    }
    
    func setToken(token: Token) async {
        KeychainWrapper.default.set(token.accessToken, forKey: AuthManager.AccessTokenKey)
        KeychainWrapper.default.set(token.refreshToken, forKey: AuthManager.RefreshTokenKey)
        KeychainWrapper.default.set(token.expiryDate, forKey: AuthManager.AccessTokenExpiryKey)
    }
}

actor AuthManager: AuthManagable {
    
    static let RefreshTokenKey = "RefreshTokenKey"
    static let AccessTokenKey = "AccessTokenKey"
    static let AccessTokenExpiryKey = "AccessTokenExpiryKey"
    
    var urlSession: URLSession
    var tokenDataProvider: TokenDataProvidable
    private var waitingTasks: [(Result<Token, Error>) -> Void] = []
    private var isRefreshing = false
    
    init(urlSessionProvider: URLSessionProvider = DefaultURLSessionProvider(), tokenDataProvider: TokenDataProvidable = DefaultTokenDataProvider()) {
        self.urlSession = urlSessionProvider.urlSession
        self.tokenDataProvider = tokenDataProvider
    }
    
    private func validateToken(token: Token) -> Bool {
        return !(token.accessToken ?? "").isEmpty && token.expiryDate?.serverDate ?? Date() > Date().addingTimeInterval(10)
    }
    
    func getToken() async throws -> Token {

        let token = Token(accessToken: tokenDataProvider.tokenString, refreshToken: nil, expiryDate: tokenDataProvider.tokenExpiryDate)
        
        if validateToken(token: token) {
            return token
        }
        
        return try await fetchValidAuthToken()
    }

    func fetchValidAuthToken() async throws -> Token {
        
        if isRefreshing {
            return try await withCheckedThrowingContinuation { continuation in
                waitingTasks.append { result in
                    continuation.resume(with: result)
                }
            }
        }
                
        isRefreshing = true
        
        let endpoint = AuthEndpoints.refreshToken
        do {
            let (data, _) = try await urlSession.data(for: endpoint.asURLRequest())
            let token = try JSONDecoder().decode(Token.self, from: data)
            if validateToken(token: token) {
                await tokenDataProvider.setToken(token: token)
                waitingTasks.forEach { $0(.success(token)) }
                waitingTasks.removeAll()
                return token
            } else {
                let error = ApiError(
                    errorCode: "ERROR-2",
                    message: "Invalid token"
                )
                thoseWhoAreWaiting(error: error)
                throw error
            }
        } catch let error as ApiError {
            thoseWhoAreWaiting(error: error)
            throw error
        } catch {
            let error = ApiError(
                errorCode: "ERROR-1",
                message: "Unknown API error \(error.localizedDescription)"
            )
            thoseWhoAreWaiting(error: error)
            throw error
        }
    }
    
    func thoseWhoAreWaiting(error: Error) {
        isRefreshing = false
        waitingTasks.forEach { $0(.failure(error)) }
        waitingTasks.removeAll()
    }
}
