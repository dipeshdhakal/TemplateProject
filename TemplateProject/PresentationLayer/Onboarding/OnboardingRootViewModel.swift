//
//  OnboardingRootViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI

class OnboardingRootViewModel: ObservableObject {
    
    @Published var onboardingSuccess: Bool = false
    
    func completeOnboarding() {
        UserDefaults.userOnboarded = true
        onboardingSuccess = true
    }
    
}
