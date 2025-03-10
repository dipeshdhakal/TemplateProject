//
//  SettingsView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appSettings : AppSettings
    @EnvironmentObject var appCoordinator : AppCoordinator

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("LINKS")
                    .foregroundColor(Color.foregroundColorLight), content: {
                    HStack {
                        Text("App URL")
                            .foregroundColor(Color.foregroundColor)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.foregroundColor)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appCoordinator.changeAppViewState(path: .webView("https://dipeshdhakal.site/"))
                    }
                })
                
                Section(header: Text("PREFRENCES")
                    .foregroundColor(Color.foregroundColorLight), content: {
                    HStack {
                        Image(systemName: "lock")
                        Toggle(isOn: $viewModel.biometricEnabled) {
                            Text("Biometric Lock")
                                .foregroundColor(Color.foregroundColor)
                        }
                    }
                })
                
                Section(header: Text("SETTINGS")
                    .foregroundColor(Color.foregroundColorLight), content: {
                    HStack {
                        Image(systemName: "person.fill.xmark")
                            .foregroundColor(Color.foregroundColor)
                        Text("Sign out")
                            .foregroundColor(Color.foregroundColor)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.foregroundColor)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UserDefaults.userLoggedIn = false
                        appCoordinator.changeAppViewState(path: .login)
                    }
                })
            }
            .navigationBarTitle("Settings")
        }
        .onChange(of: viewModel.biometricEnabled, initial: false) { oldValue, newValue in
            appSettings.appUnlocked = newValue
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
