//
//  AppRootView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import SwiftUI

struct AppRootView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var appCoordinator : AppCoordinator
    @EnvironmentObject var appSettings : AppSettings
    
    @StateObject var viewModel = AppRootViewModel()
    
    var body: some View {
        NavigationStack(path: $appCoordinator.appLaunchPath, root: {
            ProgressView()
                .navigationDestination(for: AppLaunchNavigation.self, destination: { item in
                    switch item {
                    case .home:
                        HomeView()
                            .navigationBarBackButtonHidden(true)
                    case .biometric:
                        BiometricUnlockView()
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    case .onboarding:
                        OnboardingRootView()
                            .navigationBarBackButtonHidden(true)
                    case .privacyScreen:
                        VStack {
                            EmptyView()
                        }
                        .navigationBarBackButtonHidden(true)
                    case .startup:
                        ProgressView()
                            .navigationBarBackButtonHidden(true)
                    case .webView(let urlString):
                        WebView(url: URL(string: urlString)!)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                })
        })
        .transition(.identity)
        .onChange(of: viewModel.startupCompleted, { oldValue, newValue in
            if newValue {
                appCoordinator.determineNextPath()
            }
        })
        .onChange(of: scenePhase, { oldValue , newValue in
            guard oldValue != newValue else { return }
            switch newValue {
            case .background:
                appCoordinator.changeAppViewState(path: .privacyScreen)
                appSettings.appUnlocked = false
            default:
                if !appSettings.appUnlocked && UserDefaults.biometricEnabled {
                    appCoordinator.changeAppViewState(path: .biometric)
                } else {
                    if oldValue == .inactive && !viewModel.startupCompleted {
                        // First launch
                        appCoordinator.changeAppViewState(path: .startup)
                    } else {
                        // From background
                        appCoordinator.determineNextPath()
                    }
                }
                
            }
        })
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppCoordinator())
}
