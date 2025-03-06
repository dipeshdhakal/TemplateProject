//
//  Theme.swift
//  Settld
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import SwiftUI

@MainActor
class Theme: ObservableObject {
    
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
