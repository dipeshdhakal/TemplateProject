//
//  ItemsView.swift
//  Settld
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct ItemsView: View {
    
    @StateObject var viewModel: ItemsViewModel
    @EnvironmentObject var appcoordinator : AppCoordinator
    
    var body: some View {
        VStack {
            Text("Items View")
            List {
                ForEach(viewModel.userItems) { item in
                    NavigationLink {
                        ItemDetailsView(itemDetailsViewModel: ItemDetailsViewModel(id: item.itemID))
                    } label: {
                        VStack {
                            Text(item.itemTitle)
                            Text(item.itemDate.description)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getAsyncEvents()
            }
        }
        .navigationTitle("Items")
    }
}

#Preview {
    ItemsView(viewModel: ItemsViewModel(preview: true))
        .modelContainer(PreviewContextProvider.previewContainer)
}
