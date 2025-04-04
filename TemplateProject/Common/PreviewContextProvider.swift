//
//  PreviewContextProvider.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation
import SwiftData

class PreviewContextProvider {
    static let previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: Item.self, configurations: config)
    }()
}
