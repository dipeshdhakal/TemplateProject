//
//  ItemDetailsView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import SwiftUI

struct ItemDetailsView: View {
    
    @StateObject var itemDetailsViewModel: ItemDetailsViewModel
    
    var body: some View {
        VStack {
            Text(itemDetailsViewModel.item?.itemTitle ?? "")
        }
        .navigationTitle("Item Details")
    }
}

#Preview {
    NavigationStack {
        ItemDetailsView(itemDetailsViewModel: ItemDetailsViewModel(id: "1", preview: true))
    }.modelContainer(PreviewContextProvider.previewContainer)
}
