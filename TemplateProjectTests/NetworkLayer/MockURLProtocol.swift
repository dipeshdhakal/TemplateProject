//
//  MockURLProtocol.swift
//  TemplateProjectTests
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation
@testable import TemplateProject

struct MockEndpoint: EndpointProvider {
    var scheme: String = "https"
    var baseURL: String = "example.com"
    var path: String = "/test"
    var method: RequestMethod = .get
    var queryItems: [URLQueryItem]? = nil
    var body: [String: Any]? = nil
    var mockFile: String? = nil
}

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() { }
    
    override func startLoading() {
         guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
