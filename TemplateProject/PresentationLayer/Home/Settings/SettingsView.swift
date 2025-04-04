//
//  SettingsView.swift
//  TemplateProject
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
                Group {
                    HStack{
                        Spacer()
                        VStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                            Text(viewModel.dummyUserName)
                                .font(.title)
                                .foregroundColor(Color.foregroundColor)
                            Text(viewModel.dummyEmail)
                                .font(.subheadline)
                                .foregroundColor(Color.foregroundColorLight)
                            Spacer()
                            Button(action: {
                                print("Edit Profile tapped")
                            }) {
                                Text("Edit Profile")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.system(size: 18))
                                    .padding()
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            .background(Color.blue)
                            .cornerRadius(25)
                        }
                        .padding(.vertical, 20)
                        Spacer()
                    }
                }
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
                                case .theme:
                                    HStack{
                                        Image(systemName: AppSettings.shared.currentTheme == .light ? "moon" : "moon.fill")
                                        Toggle(isOn: $viewModel.darkMode) {
                                            Text("Dark Mode")
                                                .foregroundColor(Color.foregroundColor)
                                        }
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
                                    NavigationLink(destination: DebugSwitchView()) {
                                        Text(row.title)
                                            .foregroundColor(Color.foregroundColor)
                                    }
                                }
                            }
                        })
                }
            }
            .navigationBarTitle("Settings")
            .onChange(of: viewModel.biometricEnabled, initial: false) { oldValue, newValue in
                appSettings.appUnlocked = newValue
            }
        }
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
