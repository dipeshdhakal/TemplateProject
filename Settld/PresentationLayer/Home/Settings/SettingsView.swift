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
                                appCoordinator.changeAppViewState(path: .webView("https://dipeshdhakal.site/"))
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
