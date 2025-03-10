//
//  ApiProtocol.swift
//  Settld
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

protocol URLSessionProvider: Sendable {
    var urlSession: URLSession { get }
}

final class DefaultURLSessionProvider: URLSessionProvider {
    
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
}

protocol ApiProtocol: Sendable {
    func asyncRequest<T: Decodable & Sendable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}

final actor ApiClient: ApiProtocol {
    
    var session: URLSession
    var authManager: AuthManagable
    
    init(urlSessionProvider: URLSessionProvider = DefaultURLSessionProvider(), authManager: AuthManagable = AuthManager()) {
        self.session = urlSessionProvider.urlSession
        self.authManager = authManager
    }
    
    func asyncRequest<T: Decodable & Sendable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        
        var tokenString: String?
        
        if endpoint.isAuthRequest {
            let token = try await authManager.fetchValidAuthToken()
            tokenString = token.accessToken
        }
        
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest(token: tokenString))
            return try await self.manageResponse(data: data, response: response, endpoint: endpoint, responseModel: T.self)
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(
                errorCode: "ERROR-1",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }
    
    private func manageResponse<T: Decodable & Sendable>(data: Data, response: URLResponse, endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
            guard let response = response as? HTTPURLResponse else {
                throw ApiError(
                    errorCode: "ERROR-1",
                    message: "Invalid HTTP response"
                )
            }
            switch response.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print("‼️", error)
                    throw ApiError(
                        errorCode: "ERROR-2",
                        message: "Error decoding data"
                    )
                }
            default:
                guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                    throw ApiError(
                        statusCode: response.statusCode,
                        errorCode: "ERROR-0",
                        message: "Unknown backend error"
                    )
                }
                if response.statusCode == 403 {
                    NotificationCenter.default.post(name: .userSessionExpired, object: self)
                } else if response.statusCode == 401 {
                    if endpoint.isAuthRequest {
                        _ = try await authManager.fetchValidAuthToken()
                        return try await asyncRequest(endpoint: endpoint, responseModel: T.self)
                    }
                }
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: decodedError.errorCode,
                    message: decodedError.message
                )
            }
        }
}
