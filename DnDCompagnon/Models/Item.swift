//
//  Item.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var name: String
    var itemDescription: String
    var type: ItemType
    var imageData: Data?  // Stockage binaire de l'image
    
    init(
        timestamp: Date = Date(),
        name: String,
        itemDescription: String = "",
        type: ItemType = .objet,
        imageData: Data? = nil
    ) {
        self.timestamp = timestamp
        self.name = name
        self.itemDescription = itemDescription
        self.type = type
        self.imageData = imageData
    }
}
