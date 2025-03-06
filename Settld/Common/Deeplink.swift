//
//  Deeplink.swift
//  Settld
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import Foundation

enum Deeplink {
    
    init?(rawValue: String) {
        switch rawValue {
            case "cards": self = .cards
            case "dashboard": self = .dashboard
            case "settings": self = .settings
            case "passcode": self = .passcode
            default: self = .card(rawValue)
        }
    }
        
    case dashboard
    case cards
    case card(String)
    case settings
    case passcode
    
    var selectedTab: Tab? {
        switch self {
        case .dashboard:
            return .dashboard
        case .cards:
            return .cards
        case .settings:
            return .settings
        default:
            return nil
        }
    }
}
