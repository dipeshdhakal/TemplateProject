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
                    case .privacyScreen:
                        VStack {
                            EmptyView()
                        }
                        .navigationBarBackButtonHidden(true)
                    }
                })
        })
        .onChange(of: scenePhase, { oldValue , newValue in
            guard oldValue != newValue else { return }
            switch newValue {
            case .background:
                appCoordinator.changeAppViewState(path: .privacyScreen)
                appSettings.appUnlocked = false
            default:
                if !appSettings.appUnlocked && appSettings.biometricLock {
                    appCoordinator.changeAppViewState(path: .biometric)
                } else {
                    appCoordinator.changeAppViewState(path: .home)
                }
                
            }
        })
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppCoordinator())
}
