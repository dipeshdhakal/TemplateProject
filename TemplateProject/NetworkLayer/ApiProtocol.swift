//
//  ApiProtocol.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

protocol ApiProtocol {
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}

final class ApiClient: ApiProtocol {
    
    var session: URLSession
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        self.init(session: URLSession(configuration: configuration))
    }

    init(session: URLSession) {
        self.session = session
    }
    
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            return try self.manageResponse(data: data, response: response)
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(
                errorCode: "ERROR-1",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }
    
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
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
                }
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: decodedError.errorCode,
                    message: decodedError.message
                )
            }
        }
}
