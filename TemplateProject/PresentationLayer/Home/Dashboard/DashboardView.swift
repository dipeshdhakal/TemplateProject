//
//  DashboardView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct DashboardView: View {
        
    var body: some View {
        VStack {
            Text("Dashboard View")
        }
        .navigationTitle("Dashboard")
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
