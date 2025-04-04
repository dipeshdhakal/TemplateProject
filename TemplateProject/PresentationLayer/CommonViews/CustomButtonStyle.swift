//
//  CustomButtonStyle.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding()
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut, value: 0.2)
            .background(Color.buttonColor)
            .cornerRadius(25)
    }
}
