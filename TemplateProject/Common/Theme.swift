//
//  Theme.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import SwiftUI

enum Theme: Int {
    
    case light
    case dark
    case system
    
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
        }
    }
}

extension Color {
    
    static var backgroundColor: Color {
        return Color("BackgroundColor")
    }
    
    static var foregroundColor: Color {
        return Color("ForegroundColor")
    }
    
    static var buttonColor: Color {
        return Color("ButtonColor")
    }
    
    static var foregroundLightColor: Color {
        return Color("ForegroundColorLight")
    }
}
