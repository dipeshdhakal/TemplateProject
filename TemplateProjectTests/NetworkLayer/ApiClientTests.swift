//
//  ApiClientTests.swift
//  TemplateProjectTests
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import XCTest
@testable import TemplateProject

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

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        setMockProtocol()
        
        let apiClient = ApiClient(session: session)
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
