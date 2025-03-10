//
//  ItemsManager.swift
//  Settld
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation

protocol ItemManagable: Sendable {
    var items: AsyncStream<[Item]> { get }
    func fetchItems() async throws
    func getItem(id: String) async throws -> Item
    func addItem(title: String, date: Date) async throws -> Item
    func updateItem(id: String, title: String, date: Date) async throws -> Item
    func deleteItem(id: String) async throws
}

actor ItemsManager: ItemManagable {
    
    var dataProvider: DataProvidable
    let apiClient: ApiProtocol
        
    let items: AsyncStream<[Item]>
    private let continuation: AsyncStream<[Item]>.Continuation
    
    init(dataProvider: DataProvidable = DataProvider(), apiClient: ApiProtocol = ApiClient()) {
        self.dataProvider = dataProvider
        self.apiClient = apiClient
        let stream = AsyncStream.makeStream(of: [Item].self)
        items = stream.stream
        continuation = stream.continuation
    }
    
    deinit {
        continuation.finish()
    }
    
    func fetchItems() async throws {
        let cachedItems = try await fetchCachedItems()
        continuation.yield(Array(cachedItems))
        
        let items = try await apiClient.asyncRequest(endpoint: ItemsEndpoints.getItems, responseModel: [Item].self)
        continuation.yield(Array(items))
        
        for item in items {
            try await dataProvider.addItem(title: item.itemTitle, date: item.itemDate)
        }
                
    }
    
    func getItem(id: String) async throws -> Item {
        return try await dataProvider.getItem(id: id)
    }
    
    func addItem(title: String, date: Date) async throws -> Item {
        return try await dataProvider.addItem(title: title, date: date)
    }
    
    func updateItem(id: String, title: String, date: Date) async throws -> Item {
        return try await dataProvider.updateItem(id: id, title: title, date: date)
    }
    
    func deleteItem(id: String) async throws {
        return try await dataProvider.deleteItem(id: id)
    }
    
    private func fetchCachedItems() async throws -> [Item] {
        return try await dataProvider.listItems()
    }
    
}
