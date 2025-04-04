//
//  DebugSwitchView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/4/2025.
//

import SwiftUI

struct DebugSwitchView: View {
    
    @EnvironmentObject var appCoordinator : AppCoordinator
        
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Text("Revert user onboarding")
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    UserDefaults.userOnboarded = false
                    appCoordinator.appendOnTopOfRootView(path: .onboarding)
                }
            }
            
            LazyVStack {
                HStack {
                    Text("Silumate 401")
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    NotificationCenter.default.post(name: .userSessionExpired, object: nil)
                }
            }
        }
        .padding()
    }
}
