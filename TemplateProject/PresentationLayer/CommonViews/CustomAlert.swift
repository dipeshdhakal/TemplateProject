//
//  CustomAlert.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI

@MainActor
protocol AlertPresentable {
    var isShowingAlert: Bool { get set }
    var alertDetails: AlertDetails { get }
}

struct AlertDetails: Equatable {
    let title: String
    let message: String?
    let buttons: [AlertButton]
    
    init(title: String, message: String? = nil, buttons: [AlertButton] = [AlertButton(title: "OK")]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

struct AlertButton: Identifiable, Equatable {
    let id = UUID().uuidString
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?
    let accessibilityIdentifier: String

    init(title: String, role: ButtonRole? = nil, action: (() -> Void)? = nil, accessibilityIdentifier: String = "") {
        self.title = title
        self.role = role
        self.action = action
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    static func == (lhs: AlertButton, rhs: AlertButton) -> Bool {
        lhs.title == rhs.title && lhs.role == rhs.role
    }
}

struct AlertView: ViewModifier {
    @Binding var isShowing: Bool
    let details: AlertDetails

    func body(content: Content) -> some View {
        content
            .alert(details.title, isPresented: $isShowing) {
                ForEach(details.buttons) { button in
                    Button(role: button.role, action: {
                        button.action?()
                        isShowing = false
                    }) {
                        Text(button.title)
                    }
                    .accessibilityIdentifier(button.accessibilityIdentifier)
                }
            } message: {
                Text(details.message ?? "")
            }
    }
}


extension View {
    func showAlert(isShowing: Binding<Bool>, details: AlertDetails) -> some View {
        self.modifier(AlertView(isShowing: isShowing, details: details))
    }
}
