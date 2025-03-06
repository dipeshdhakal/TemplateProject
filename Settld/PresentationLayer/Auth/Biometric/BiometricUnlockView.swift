//
//  BiometricUnlockView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 28/5/2024.
//

import SwiftUI

struct BiometricUnlockView: View {
    
    @ObservedObject var viewModel = BiometricUnlockViewModel()
    @EnvironmentObject var appSettings: AppSettings
    @State var firstLoad = true
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.systemImageName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            Text("Biometric.Failed.Title", tableName: "Shared")
                  .frame(minWidth: 0, maxWidth: .infinity)
                  .foregroundColor(Color.white)
            .padding()
        }
        .onAppear {
            Task {
                let success = await viewModel.attemptBiometricAuthentication()
                await MainActor.run {
                    if success {
                        appSettings.appUnlocked = true
                    }
                }
            }
        }
        .showAlert(isShowing: $viewModel.isShowingAlert, details: viewModel.alertDetails)
    }
}

#Preview {
    BiometricUnlockView(viewModel: BiometricUnlockViewModel())
}
