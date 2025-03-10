//
//  ApiClientTests.swift
//  SettldTests
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import XCTest
@testable import Settld

final class ApiClientTests: XCTestCase {

    struct TestModel: Codable {
        let id: Int
        let title: String
    }

    private func setMockProtocol() {
        MockURLProtocol.requestHandler = { request in
            let exampleData =
            """
            {"id":1,"title":"Hello, world!"}
            """
            .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
    }
    
    func testAsyncRequest() async throws {

        setMockProtocol()
        
        let apiClient = ApiClient(urlSessionProvider: MockURLSessionProvider(), authManager: MockAuthManager())
        let endpoint = MockEndpoint()

        do {
            let result = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: TestModel.self)
            XCTAssertEqual(result.id, 1)
            XCTAssertEqual(result.title, "Hello, world!")
        } catch {
            print(error)
            throw error
        }

    }
}

final class MockURLSessionProvider: URLSessionProvider {
    
    var urlSession: URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: sessionConfiguration)
    }
}

final class MockAuthManager: AuthManagable {
    
    func getToken() async throws -> Token {
        return Token(accessToken: "tesAcessToken", refreshToken: nil, expiryDate: "2025-11-02T02:50:12.208Z")
    }
    
    func fetchValidAuthToken() async throws -> Token {
        return Token(accessToken: "tesAcessToken", refreshToken: nil, expiryDate: "2025-11-02T02:50:12.208Z")
    }
}
