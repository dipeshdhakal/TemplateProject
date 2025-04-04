//
//  AuthEndpoints.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

enum AuthEndpoints: EndpointProvider {    

    case login(userName: String, password: String)
    case register(id: String)
    case refreshToken(refreshToken: String)

    var path: String {
        switch self {
        case .login:
            return "/api/v2/login"
        case .register:
            return "/api/v2/register"
        case .refreshToken:
            return "/api/v2/refresh"
        }
    }

    var method: RequestMethod {
        switch self {
        case .refreshToken:
            return .get
        case .login, .register:
            return .post
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .login(let userName, let password):
            return [URLQueryItem(name: "userName", value: userName), URLQueryItem(name: "password", value: password)]
        default:
            return nil
        }
    }

    var body: [String: Any]? {
        return nil
    }
    
    var isAuthRequest: Bool {
        switch self {
        case .login:
            return true
        case .register, .refreshToken:
            return false
        }
    }
    
    var mockFile: String? {
        return ""
    }
    
}
