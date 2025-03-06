//
//  AppSettings.swift
//  Settld
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import SwiftUI

class AppSettings: ObservableObject {
    
    @Published var appUnlocked: Bool = false
    
    func updateAppUnlock(value: Bool) {
        appUnlocked = value
    }

}

