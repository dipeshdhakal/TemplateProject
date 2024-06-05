//
//  SettingsView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel

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
                
                Section(header: Text("PREFRENCES")
                    .foregroundColor(Color.foregroundColorLight), content: {
                    HStack{
                        Image(systemName: "globe")
                        Picker(selection: $viewModel.selectedLanguage, label: Text("Language")
                            .foregroundColor(Color.foregroundColor)) {
                            ForEach(viewModel.languages, id: \.self) { language in
                                Text(language.rawValue)
                                    .foregroundColor(Color.foregroundColor)
                            }
                        }
                    }
                    
                    HStack{
                        Image(systemName: AppSettings.shared.currentTheme == .light ? "moon" : "moon.fill")
                        Toggle(isOn: $viewModel.darkMode) {
                            Text("Dark Mode")
                                .foregroundColor(Color.foregroundColor)
                        }
                    }
                        
                    HStack {
                        Image(systemName: "lock")
                        Toggle(isOn: $viewModel.biometricUnlock) {
                            Text("Biometric Lock")
                                .foregroundColor(Color.foregroundColor)
                        }
                    }
                })
            }
            .navigationBarTitle("Settings")
        }
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
