//
//  ForceUpgradeView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 7/3/2025.
//

import SwiftUI

struct ForceUpgradeView: View {
    var body: some View {
        VStack {
            Text("Upgrade the app to latest version to continue using")
            Button(action: {
                
            }, label: {
                Text("Upgrade now")
            })
        }
        .presentationDetents([.height(300)])
        .interactiveDismissDisabled()
    }
}
