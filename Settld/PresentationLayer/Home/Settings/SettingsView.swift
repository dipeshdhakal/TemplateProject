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
                
                ForEach(SettingsViewModel.SettingsSection.allCases, id: \.self) { section in
                    Section(header: Text(section.title)
                        .foregroundColor(Color.foregroundColor), content: {
                            ForEach(section.rows, id: \.self) { row in
                                switch row {
                                case .appURL:
                                    HStack {
                                        Text(row.title)
                                            .foregroundColor(Color.foregroundColor)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.foregroundColor)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        appCoordinator.changeAppViewState(path: .webView("https://dipeshdhakal.site/"))
                                    }
                                case .biometricLock:
                                    HStack {
                                        Image(systemName: "lock")
                                        Toggle(isOn: $viewModel.biometricEnabled) {
                                            Text(row.title)
                                                .foregroundColor(Color.foregroundColor)
                                        }
                                    }
                                case .signOut:
                                    HStack {
                                        Image(systemName: "person.fill.xmark")
                                            .foregroundColor(Color.foregroundColor)
                                        Text(row.title)
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
                                case .debugSwitches:
                                    HStack {
                                        Text(row.title)
                                            .foregroundColor(Color.foregroundColor)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.foregroundColor)
                                    }
                                }
                            }
                        })
                }
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
