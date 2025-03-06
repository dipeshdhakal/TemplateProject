import SwiftUI

struct NotificationPreferencesView: View {

    @ObservedObject var viewModel: NotificationPreferencesViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: viewModel.notificationIsEnabled ? "bell.slash" : "bell")
                .resizable()
                .frame(width: 24, height: 24)
            Text(viewModel.headingText)
                .font(.title)
                .multilineTextAlignment(.center)
            Text(viewModel.detailsText)
                .font(.body)
                .multilineTextAlignment(.center)
            Text(viewModel.instructionsText)
                .multilineTextAlignment(.center)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text(viewModel.actionButtonText)
            })
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack {
        NotificationPreferencesView(viewModel: NotificationPreferencesViewModel())
        NotificationPreferencesView(viewModel: NotificationPreferencesViewModel())
    }
}

class NotificationPreferencesViewModel: ObservableObject {

    @Published var notificationIsEnabled = true
    @Published var headingText: String = "Notifications are off"
    @Published var detailsText: String = "To make any changes to your notification preferences, go to your phone’s settings."
    @Published var instructionsText: String = "1. Open Settings\n2. Go to Notifications\n3. Turn notifications on"
    @Published var actionButtonText: String = "Go to settings"

    init() {
        notificationIsEnabled = true
    }
}
