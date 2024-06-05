//
//  TemplateProjectApp.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI
import SwiftData

@main
struct TemplateProjectApp: App {
    
    @ObservedObject var appSettings = AppSettings.shared
    @StateObject var appCoordinator: AppCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
            .preferredColorScheme(appSettings.currentTheme.colorScheme)
            .environmentObject(appCoordinator)
            .environmentObject(appSettings)
            .onOpenURL { url in
                appCoordinator.checkDeepLink(url: url)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: launchUrl(userActivity:))
        }
    }
    
    func launchUrl(userActivity: NSUserActivity) {
      print("launchUrl continue user activity: \(userActivity.activityType)")
    }    
}
