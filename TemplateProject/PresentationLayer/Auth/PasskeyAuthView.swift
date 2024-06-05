//
//  PasskeyViewController.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 4/6/2024.
//

import SwiftUI
import Combine

var cancelabels = Set<AnyCancellable>()

struct PasskeyAuthView: View {
    
    enum ViewState {
        case entry
        case signedUp
        case signedIn
        
        var buttonTitle: String {
            switch self {
            case .entry:
                return "Register with passkey"
            case .signedUp:
                return "Login with passkey"
            case .signedIn:
                return "Logout"
            }
        }
    }
    
    @State private var keyWindow: UIWindow?
    @State var viewState: ViewState = .entry
    
    var body: some View {
        VStack {
            Button(action: {
                switch viewState {
                case .entry:
                    PKManager.signUp(anchor: UIApplication.shared.keyWindow!)
                case .signedUp:
                    PKManager.signIn(anchor: UIApplication.shared.keyWindow!)
                case .signedIn:
                    viewState = .entry
                }
                
            }) {
                Text(viewState.buttonTitle)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(Color.white)
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
        }
        .onAppear {
            NotificationCenter.default.publisher(for: .userLoggedIn).sink { _ in
                viewState = .signedIn
            }
            .store(in: &cancelabels)
            NotificationCenter.default.publisher(for: .userRegistered).sink { _ in
                viewState = .signedUp
            }
            .store(in: &cancelabels)
        }
    }
}

#Preview {
    PasskeyAuthView()
}

