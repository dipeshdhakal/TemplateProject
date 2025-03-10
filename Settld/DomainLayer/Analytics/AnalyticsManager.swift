//
//  AnalyticsManager.swift
//  Settld
//
//  Created by Dipesh Dhakal on 7/3/2025.
//

enum EventName {
    case login
}

enum ScreenName {
    case loginView
}

actor AnalyticsManager {
    
    let shared = AnalyticsManager()
    
    func logEvent(event: EventName, paremeters: [String: Any]) {
        print("Event: \(event)")
    }
    
    func logError(error: Error, paremeters: [String: Any]) {
        print("Error: \(error.localizedDescription)")
    }
    
    func logScreen(screen: ScreenName, paremeters: [String: Any]) {
        print("Screen: \(screen)")
    }
    
}
