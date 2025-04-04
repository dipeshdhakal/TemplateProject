//
//  MockApiClient.swift
//  TemplateProjectTests
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import XCTest
@testable import TemplateProject

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}

class MockApiClient: Mockable, ApiProtocol {

    var sendError: Bool
    var mockFile: String?

    init(sendError: Bool = false, mockFile: String? = nil) {
        self.sendError = sendError
        self.mockFile = mockFile
    }

    func asyncRequest<T>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T where T: Decodable {
        if sendError {
            throw ApiError(statusCode: 0, errorCode: "0", message: "AsyncFailed")
        } else {
            let filename = mockFile ?? endpoint.mockFile!
            return loadJSON(filename: filename, type: responseModel.self)
        }
    }

}
