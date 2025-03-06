//
//  DataProvidable.swift
//  Settld
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

/// Data layer abstraction
protocol DataProvidable: Sendable {
    func listItems() async throws -> [Item]
    func getItem(id: String) async throws -> Item
    @discardableResult func addItem(title: String, date: Date) async throws -> Item
    func updateItem(id: String, title: String, date: Date) async throws -> Item
    func deleteItem(id: String) async throws
}
