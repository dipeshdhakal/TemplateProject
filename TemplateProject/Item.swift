//
//  Item.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 25/5/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
