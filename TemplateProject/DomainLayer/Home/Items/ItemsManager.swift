//
//  ItemsManager.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation

protocol ItemManagable {
    var itemsStream: AsyncStream<[Item]> { get set }
    func fetchItems() async throws
    func getItem(id: String) async throws -> Item
    func addItem(title: String, date: Date) async throws -> Item
    func updateItem(id: String, title: String, date: Date) async throws -> Item
    func deleteItem(id: String) async throws
}

class ItemsManager: ItemManagable {
    
    var dataProvider: DataProvidable
    let apiClient: ApiProtocol
    
    private var continuation: AsyncStream<[Item]>.Continuation?
    
    // https://forums.swift.org/t/unlike-other-continuations-in-swift-asyncstream-continuation-supports-escaping/53254/5
    lazy var itemsStream = AsyncStream<[Item]> { continuation in
        self.continuation = continuation
        continuation.onTermination = { @Sendable _ in
            // Stop API calls if
        }
    }
    
    init(dataProvider: DataProvidable = DataProvider(), apiClient: ApiProtocol = ApiClient()) {
        self.dataProvider = dataProvider
        self.apiClient = apiClient
    }
    
    func fetchItems() async throws {
        let cachedItems = try await fetchCachedItems()
        continuation?.yield(Array(cachedItems))
        
        let items = try await apiClient.asyncRequest(endpoint: ItemsEndpoints.getItems, responseModel: [Item].self)
        continuation?.yield(Array(cachedItems))
        
        for item in items {
            try dataProvider.addItem(title: item.itemTitle, date: item.itemDate)
        }
        
    }
    
    func getItem(id: String) async throws -> Item {
        return try dataProvider.getItem(id: id)
    }
    
    func addItem(title: String, date: Date) async throws -> Item {
        return try dataProvider.addItem(title: title, date: date)
    }
    
    func updateItem(id: String, title: String, date: Date) async throws -> Item {
        return try dataProvider.updateItem(id: id, title: title, date: date)
    }
    
    func deleteItem(id: String) async throws {
        return try dataProvider.deleteItem(id: id)
    }
    
    private func fetchCachedItems() async throws -> [Item] {
        return try dataProvider.listItems()
    }
    
}
