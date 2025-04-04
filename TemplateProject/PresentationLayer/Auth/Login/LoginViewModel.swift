//
//  LoginViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI

class LoginViewModel: ObservableObject {
        
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginButtonDisabled: Bool = true
    @Published var isLoginInProgress: Bool = false
    @Published var isLoginSuccess: Bool = false
    @Published var isLoginFailed: Bool = false
    @Published var loginErrorMessage: String = ""
    @Published var loginSuccess: Bool = false
        
    func validateEmail() {
        if email.isValidEmail {
            isLoginButtonDisabled = false
        } else {
            isLoginButtonDisabled = true
        }
    }
    
    func validatePassword() {
        if password.count > 5 {
            isLoginButtonDisabled = false
        } else {
            isLoginButtonDisabled = true
        }
    }
    
    func login() {
        UserDefaults.userLoggedIn = true
        loginSuccess = true
    }
            
           
}

extension String {
    var isValidEmail: Bool {
        return true
    }
}
