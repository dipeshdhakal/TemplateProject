//
//  LoginView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appCoordinator : AppCoordinator
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
                .padding()
            TextField("Email", text: .constant(""))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: .constant(""))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login") {
                loginViewModel.login()
            }
            .padding()
            .buttonStyle(.bordered)
        }
        .accessibilityIdentifier("LoginView")
        .onChange(of: loginViewModel.loginSuccess) { oldValue, newValue in
            if newValue {
                appCoordinator.changeAppViewState(path: .home)
            }
        }
    }
}
