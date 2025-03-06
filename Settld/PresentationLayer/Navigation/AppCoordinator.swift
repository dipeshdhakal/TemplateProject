//
//  AppCoordinator.swift
//  Settld
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
                    case .cards:
                        currentItemID = secondComponent
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func appendOnTopOfRootView(path: AppLaunchNavigation) {
        appLaunchPath.removeAll(where: { $0 != .startup })
        appLaunchPath.append(path)
    }
    
    func determineNextPath() {
        if UserDefaults.userOnboarded {
            if UserDefaults.userLoggedIn {
                appendOnTopOfRootView(path: .home)
            } else {
                appendOnTopOfRootView(path: .login)
            }
        } else {
            appendOnTopOfRootView(path: .onboarding)
        }
    }
    
    func changeAppViewState(path: AppLaunchNavigation) {
        switch path {
        case .home, .login, .onboarding:
            appendOnTopOfRootView(path: path)
        case .biometric:
            // When faceID is shown, scenePhase goes to background triggering infinite loop. So, we need to check if biometric is already in the path
            if appLaunchPath.last != .biometric {
                appLaunchPath.append(path)
            }
        case .privacyScreen, .webView:
            appLaunchPath.append(path)
        case .startup:
            appLaunchPath = [path]
        }
    }
}

enum Tab: String {
    case dashboard, cards, settings
}

enum AppLaunchNavigation: Hashable, Equatable {
    case login
    case onboarding
    case home
    case biometric
    case privacyScreen
    case startup
    case webView(String)
}
