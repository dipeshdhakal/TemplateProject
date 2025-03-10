//
//  AuthManagerTests.swift
//  SettldTests
//
//  Created by Dipesh Dhakal on 10/3/2025.
//

import XCTest
@testable import Settld

final class AuthManagerTests: XCTestCase {
    
    var authManager: AuthManager!
    var mockTokenDataProvider: MockTokenDataProvider!
    var mockURLSessionProvider: MockURLSessionProvider!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockTokenDataProvider = MockTokenDataProvider()
        mockURLSessionProvider = MockURLSessionProvider()
        authManager = AuthManager(urlSessionProvider: mockURLSessionProvider, tokenDataProvider: mockTokenDataProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testGetToken() async {
        do {
            let token = try await authManager.getToken()
            XCTAssertNotNil(token.accessToken)
            XCTAssertEqual(token.accessToken, mockTokenDataProvider.tokenString)
            XCTAssertEqual(token.expiryDate, mockTokenDataProvider.tokenExpiryDate)
        } catch {
            XCTFail("Failed to get token")
        }
    }
    
    func testGetTokenTriggersFetchIfTokenExpired() async {
        mockTokenDataProvider.testCases = .getTokenExpired
        
        MockURLProtocol.requestHandler = { request in
            let exampleData =
            """
            {"accessToken":"testAccessToken", "refreshToken": "testrefreshToken", "expiryDate": "2025-11-02T02:50:12.208Z"}
            """
            .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
        
        do {
            let token = try await authManager.getToken()
            mockTokenDataProvider.testCases = .success
            XCTAssertNotNil(token.accessToken)
            XCTAssertEqual(token.accessToken, mockTokenDataProvider.tokenString)
            XCTAssertEqual(token.expiryDate, mockTokenDataProvider.tokenExpiryDate)
        } catch {
            XCTFail("Failed to get token")
        }
    }
    
    func testGetTokenFailsIfAPIError() async throws {
        mockTokenDataProvider.testCases = .getTokenExpired
        MockURLProtocol.requestHandler = { request in
            let exampleData =
            """
            {"error":"error"}
            """
            .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 500, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
        
        do {
            _ = try await authManager.getToken()
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchValidAuthToken() async {
        
        MockURLProtocol.requestHandler = { request in
            let exampleData =
            """
            {"accessToken":"testAccessToken", "refreshToken": "testRefreshToken", "expiryDate": "2025-11-02T02:50:12.208Z"}
            """
            .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
        
        do {
            let token = try await authManager.fetchValidAuthToken()
            XCTAssertNotNil(token.accessToken)
            XCTAssertEqual(token.accessToken, mockTokenDataProvider.tokenString)
            XCTAssertEqual(token.expiryDate, mockTokenDataProvider.tokenExpiryDate)
        } catch {
            XCTFail("Failed to fetch valid token")
        }
    }
    
    func testFetchTokenGetsCalledOnlyOnce() async throws {
        
        MockURLProtocol.requestHandler = { request in
            let exampleData =
            """
            {"accessToken":"testToken","expiryDate":"2025-11-02T02:50:12.208Z"}
            """
            .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
        
        let task1 = Task { [weak authManager, weak mockTokenDataProvider] in
            do {
                let token = try await authManager?.fetchValidAuthToken()
                XCTAssertNotNil(token?.accessToken)
                XCTAssertEqual(token?.accessToken, mockTokenDataProvider?.tokenString)
                XCTAssertEqual(token?.expiryDate, mockTokenDataProvider?.tokenExpiryDate)
            } catch {
                XCTFail("Failed to fetch valid token")
            }
        }
        
        let task2 = Task { [weak authManager, weak mockTokenDataProvider] in
            do {
                let token = try await authManager?.fetchValidAuthToken()
                XCTAssertNotNil(token?.accessToken)
                XCTAssertEqual(token?.accessToken, mockTokenDataProvider?.tokenString)
                XCTAssertEqual(token?.expiryDate, mockTokenDataProvider?.tokenExpiryDate)
            } catch {
                XCTFail("Failed to fetch valid token")
            }
        }
        
        
        _ = await [task1.value, task2.value]
        XCTAssertEqual(mockTokenDataProvider.setTokenCallCount, 1)
    }

}

class MockTokenDataProvider: TokenDataProvidable, @unchecked Sendable {
    
    var testCases: TestCases = .success
    var mockTokenString = "testAccessToken"
    var mockTokenExpiryDate = "2025-11-02T02:50:12.208Z"
    var setTokenCallCount = 0
    
    enum TestCases: Sendable {
        case getTokenExpired
        case fetchTokenFailed
        case success
    }
    
    var tokenString: String? {
        return mockTokenString
    }
    
    var tokenExpiryDate: String? {
        if testCases == .getTokenExpired {
            return "2023-11-02T02:50:12.208Z"
        }
        return mockTokenExpiryDate
    }
    
    func setToken(token: Settld.Token) async {
        setTokenCallCount += 1
        mockTokenString = token.accessToken!
        mockTokenExpiryDate = token.expiryDate!
    }
    
}
