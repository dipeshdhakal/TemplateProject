//
//  ItemDetailsViewModel.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 27/5/2024.
//

import Foundation

class ItemDetailsViewModel: ObservableObject {
    
    @Published var item: Item?
    @Published var preview: Bool
    
    init(id: String, preview: Bool = false) {
        self.preview = preview
        getItem()
    }
    
    func getItem() {
        if preview {
            item = Item.previewItems.randomElement()!
            return
        }
        
    }
    
}
