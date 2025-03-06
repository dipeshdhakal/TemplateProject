//
//  OnboardingRootView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI

struct OnboardingRootView: View {
    
    @EnvironmentObject var appCoordinator : AppCoordinator
    @StateObject var onboardingRootViewModel = OnboardingRootViewModel()
    
    var body: some View {
        VStack {
            Text("Onboarding")
                .font(.title)
                .padding()
            Button("Continue") {
                onboardingRootViewModel.completeOnboarding()
            }
            .padding()
            .buttonStyle(.bordered)
        }
        .onChange(of: onboardingRootViewModel.onboardingSuccess) { oldValue, newValue in
            if newValue {
                appCoordinator.changeAppViewState(path: .home)
            }
        }
    }
}
