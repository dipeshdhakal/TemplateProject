//
//  AppCoordinator.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//
import Foundation
import SwiftUI
@preconcurrency import Combine

@MainActor
class AppCoordinator: ObservableObject {
    
    @Published var currentTab: Tab = .dashboard
    @Published var deeplink: Deeplink?
    @Published var currentItemID: String?
    @Published var appLaunchPath : [AppLaunchNavigation] = []
    var cancellables = Set<AnyCancellable>()
    
    var sessionExpiryNotification = NotificationCenter.default.publisher(for: .userSessionExpired)
    
    init() {
        sessionExpiryNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UserDefaults.userLoggedIn = false
                self?.changeAppViewState(path: .login)
        }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }

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
    
    func appendOnTopOfRootView(path: AppLaunchNavigation) {
        appLaunchPath.removeAll(where: { $0 != .startup })
        appLaunchPath.append(path)
    }
    
    func determineNextPath(shouldAddBiometricOnTop: Bool) {
        if UserDefaults.userOnboarded {
            if UserDefaults.userLoggedIn {
                appendOnTopOfRootView(path: .home)
            } else {
                appendOnTopOfRootView(path: .login)
            }
        } else {
            appendOnTopOfRootView(path: .onboarding)
        }
        if shouldAddBiometricOnTop {
            changeAppViewState(path: .biometric)
        }
    }
    
    func changeAppViewState(path: AppLaunchNavigation) {
        guard path != appLaunchPath.last else {
            return
        }
        switch path {
        case .home, .login, .onboarding:
            appendOnTopOfRootView(path: path)
        case .biometric, .auth, .privacyScreen, .webView:
            appLaunchPath.append(path)
        case .startup:
            appLaunchPath = [path]
        }
    }
    
    func removePath(path: AppLaunchNavigation) {
        appLaunchPath.removeAll(where: { $0 == path})
    }
    
}

enum Tab: String {
    case dashboard, items, settings
}

enum AppLaunchNavigation: Hashable, Equatable {
    case login
    case onboarding
    case home
    case auth
    case biometric
    case privacyScreen
    case startup
    case webView(String)
}
