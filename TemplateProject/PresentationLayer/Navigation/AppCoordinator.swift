//
//  AppCoordinator.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    
    @Published var currentTab: Tab = .dashboard
    @Published var deeplink: Deeplink?
    @Published var currentItemID: String?
    @Published var appLaunchPath : [AppLaunchNavigation] = []

    func checkDeepLink(url: URL) {
        
        if url.pathComponents.count > 1 {
            if let currentDeeplink = Deeplink(rawValue: url.pathComponents[1]), let deepLinkTab = currentDeeplink.selectedTab {
                currentTab = deepLinkTab
                let secondComponent: String?
                if url.pathComponents.count > 2 {
                    secondComponent = url.pathComponents[2]
                    switch currentTab {
                    case .items:
                        currentItemID = secondComponent
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func changeAppViewState(path: AppLaunchNavigation) {
        switch path {
        case .home:
            appLaunchPath = [path]
        case .biometric:
            appLaunchPath.append(path)
        case .auth:
            appLaunchPath.append(path)
        case .privacyScreen:
            appLaunchPath.append(path)
        }
    }
}

enum Tab: String {
    case dashboard, items, settings
}

enum AppLaunchNavigation: Hashable {
    case home
    case biometric
    case auth
    case privacyScreen
}
