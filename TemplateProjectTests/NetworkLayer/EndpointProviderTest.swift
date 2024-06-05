//
//  EndpointProviderTest.swift
//  TemplateProjectTests
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import XCTest
@testable import TemplateProject

final class EndpointProviderTest: XCTestCase {

    func testAsURLRequest() {
        let mockEndpointProvider = MockEndpoint()
        let urlRequest = try? mockEndpointProvider.asURLRequest()
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://example.com/test")
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["X-Use-Cache"], "true")
    }
}
