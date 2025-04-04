//
//  DataProvider.swift
//  XeroProgrammingExercise
//
//  Created by Dipesh Dhakal on 16/10/2023.
//

import Foundation
import SwiftData

// custom errors
enum DataFetchError: Error {
    case databasefetchFailed
    case genericError
}

/// A concrete implementation of data layer; Responsible for doing data operations; In this case is SwiftData
class DataProvider: DataProvidable {
    // shared context for database operations
    static let modelContext: ModelContext? = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: isUITest) // store in-memory if running from UI test
            let container = try ModelContainer(for: Item.self, configurations: config)
            return ModelContext(container)
        } catch {
            assertionFailure(error.localizedDescription, file: #file, line: #line)
            return nil
        }
    }()

    /// A model context
    var context: ModelContext?

    init(context: ModelContext? = nil) {
        if let context {
            self.context = context
        } else {
            self.context = DataProvider.modelContext
        }
    }

    func listItems() throws -> [Item] {
        do {
            return try context?.fetch(FetchDescriptor<Item>(sortBy: [SortDescriptor(\.itemDate, order: .reverse)])) ?? []
        } catch {
            throw error
        }
    }

    func getItem(id: String) throws -> Item {
        do {
            let fetchDescriptor = FetchDescriptor<Item>(predicate: #Predicate { item in
                item.itemID == id
            })

            if let invoice = try context?.fetch(fetchDescriptor).first {
                return invoice
            } else {
                throw DataFetchError.databasefetchFailed
            }
        } catch {
            throw error
        }
    }

    @discardableResult func addItem(title: String, date: Date) throws -> Item {
        do {
            let newItem = Item(itemTitle: title, itemDate: date)
            context?.insert(newItem)
            try context?.save()
            return newItem
        } catch {
            throw error
        }
    }

    func updateItem(id: String, title: String, date: Date) throws -> Item {
        do {
            let item = try getItem(id: id)
            item.itemTitle = title
            item.itemDate = date
            try context?.save()
            return item
        } catch {
            throw error
        }
    }

    func deleteItem(id: String) throws {
        do {
            let item = try getItem(id: id)
            context?.delete(item)
        } catch {
            throw error
        }
    }
}
