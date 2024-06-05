//
//  ItemsEndpoint.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation

enum ItemsEndpoints: EndpointProvider {

    case getItems
    case getItem(id: String)
    case addItem(item: Item)

    var path: String {
        switch self {
        case .getItems:
            return "/api/v2/items"
        case .getItem:
            return "/api/v2/item"
        case .addItem:
            return "/api/v2/items/add"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getItems, .getItem:
            return .get
        case .addItem:
            return .post
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getItem(let itemID):
            return [URLQueryItem(name: "itemID", value: itemID)]
        default:
            return nil
        }
    }

    var body: [String: Any]? {
        switch self {
        case .addItem(let item):
            return ["itemID": item.itemID]
        default:
            return nil
        }
    }

    var mockFile: String? {
        switch self {
        case .getItems:
            return "_getItems"
        case .getItem:
            return "_getItem"
        case .addItem:
            return "_addItem"
        }
    }
}
