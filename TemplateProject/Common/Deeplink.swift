//
//  Deeplink.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import Foundation

enum Deeplink {
    
    init?(rawValue: String) {
        switch rawValue {
            case "items": self = .items
            case "dashboard": self = .dashboard
            case "settings": self = .settings
            case "passcode": self = .passcode
            default: self = .item(rawValue)
        }
    }
        
    case dashboard
    case items
    case item(String)
    case settings
    case passcode
    
    var selectedTab: Tab? {
        switch self {
        case .dashboard:
            return .dashboard
        case .items:
            return .items
        case .settings:
            return .settings
        default:
            return nil
        }
    }
}
