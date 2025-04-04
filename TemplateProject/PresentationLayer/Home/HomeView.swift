//
//  HomeView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appCoordinator : AppCoordinator
    
    var body: some View {
        TabView(selection: $appCoordinator.currentTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .tag(Tab.dashboard)
            
            ItemsView(viewModel: ItemsViewModel())
                .tabItem {
                    Label("Items", systemImage: "flag")
                }
                .tag(Tab.items)
            
            SettingsView(viewModel: SettingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(AppCoordinator())
}
