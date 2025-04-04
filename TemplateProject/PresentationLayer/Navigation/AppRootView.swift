//
//  AppRootView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import SwiftUI

struct AppRootView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var appCoordinator : AppCoordinator
    @EnvironmentObject var appSettings : AppSettings
    
    @StateObject var viewModel = AppRootViewModel()
    @State var beenToBackground = false
    
    var body: some View {
        NavigationStack(path: $appCoordinator.appLaunchPath, root: {
            Text("App launching...")
                .navigationDestination(for: AppLaunchNavigation.self, destination: { item in
                    switch item {
                    case .home:
                        HomeView()
                            .navigationBarBackButtonHidden(true)
                    case .biometric:
                        BiometricUnlockView()
                            .navigationBarBackButtonHidden(true)
                    case .auth:
                        PasskeyAuthView()
                            .navigationBarBackButtonHidden(true)
                    case .onboarding:
                        OnboardingRootView()
                            .navigationBarBackButtonHidden(true)
                    case .privacyScreen:
                        VStack {
                            EmptyView()
                        }
                        .accessibilityIdentifier("PrivacyView")
                        .navigationBarBackButtonHidden(true)
                    case .startup:
                        ProgressView()
                            .navigationBarBackButtonHidden(true)
                    case .webView(let urlString):
                        if let url = URL(string: urlString) {
                            WebView(url: url)
                        }
                    case .login:
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    }
                })
        })
        .transition(.identity)
        .onChange(of: viewModel.startupCompleted, { oldValue, newValue in
            if newValue {
                appCoordinator.determineNextPath(shouldAddBiometricOnTop: !appSettings.appUnlocked && UserDefaults.biometricEnabled)
            }
        })
        .sheet(isPresented: $viewModel.shouldForceUpgrade) {
            ForceUpgradeView()
        }
        .onChange(of: scenePhase, { oldValue , newValue in
            guard oldValue != newValue else { return }
            switch newValue {
            case .background:
                beenToBackground = true
                appCoordinator.changeAppViewState(path: .privacyScreen)
                appSettings.appUnlocked = false
            case .active:
                appCoordinator.removePath(path: .privacyScreen)
                if beenToBackground && oldValue == .inactive && !appSettings.appUnlocked && UserDefaults.biometricEnabled {
                    appCoordinator.changeAppViewState(path: .biometric)
                }
            default:
                break
            }
        })
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppCoordinator())
}
