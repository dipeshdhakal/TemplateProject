//
//  ItemsManager.swift
//  Settld
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation

protocol ItemManagable: Sendable {
    var stream: AsyncStream<[Item]> { get }
    func fetchItems() async throws
    func getItem(id: String) async throws -> Item
    func addItem(title: String, date: Date) async throws -> Item
    func updateItem(id: String, title: String, date: Date) async throws -> Item
    func deleteItem(id: String) async throws
}

actor ItemsManager: @preconcurrency ItemManagable {
    
    var dataProvider: DataProvidable
    let apiClient: ApiProtocol
    
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0388-async-stream-factory.md
    var streamContinuation = AsyncStream.makeStream(of: [Item].self)
    
    var stream: AsyncStream<[Item]> {
        return streamContinuation.stream
    }
    
    init(dataProvider: DataProvidable = DataProvider(), apiClient: ApiProtocol = ApiClient()) {
        self.dataProvider = dataProvider
        self.apiClient = apiClient
    }
    
    deinit {
        streamContinuation.continuation.finish()
    }
    
    func fetchItems() async throws {
        let cachedItems = try await fetchCachedItems()
        streamContinuation.continuation.yield(Array(cachedItems))
        
//        let items = try await apiClient.asyncRequest(endpoint: ItemsEndpoints.getItems, responseModel: [Item].self)
//        streamContinuation.continuation.yield(Array(cachedItems))
        
//        for item in items {
//            try await dataProvider.addItem(title: item.itemTitle, date: item.itemDate)
//        }
        
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
