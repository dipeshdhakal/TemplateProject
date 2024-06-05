//
//  ItemsViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    
    let itemsManager: ItemManagable
    let preview: Bool

    init(itemsManager: ItemManagable = ItemsManager(), preview: Bool = false) {
        self.itemsManager = itemsManager
        self.preview = preview
        
        Task {
            await getAsyncEvents()
        }
    }
    
    @Published var userItems: [Item] = []
    @Published var eventError: Error?
    private var cancellables: Set<AnyCancellable> = []

    func getAsyncEvents() async {
        
        if preview {
            userItems = Item.previewItems
            return
        }
        
        do {
            try await itemsManager.fetchItems()
        } catch {
            await MainActor.run {
                eventError = error
            }
        }
        await observeStream()
    }
    
    private func observeStream() async {
        for await items in self.itemsManager.itemsStream {
            await MainActor.run {
                self.userItems = items
            }
        }
    }
}
