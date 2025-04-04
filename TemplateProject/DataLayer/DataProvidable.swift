//
//  DataProvidable.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

/// Data layer abstraction
protocol DataProvidable {
    func listItems() throws -> [Item]
    func getItem(id: String) throws -> Item
    @discardableResult func addItem(title: String, date: Date) throws -> Item
    func updateItem(id: String, title: String, date: Date) throws -> Item
    func deleteItem(id: String) throws
}
