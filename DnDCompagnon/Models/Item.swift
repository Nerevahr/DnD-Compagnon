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
    
    // Propriétés spécifiques aux armures
    var armorCategory: ArmorCategory?  // Catégorie d'armure si c'est une armure
    var baseArmorClass: Int?           // CA de base de l'armure
    
    init(
        timestamp: Date = Date(),
        name: String,
        itemDescription: String = "",
        type: ItemType = .objet,
        imageData: Data? = nil,
        armorCategory: ArmorCategory? = nil,
        baseArmorClass: Int? = nil
    ) {
        self.timestamp = timestamp
        self.name = name
        self.itemDescription = itemDescription
        self.type = type
        self.imageData = imageData
        self.armorCategory = armorCategory
        self.baseArmorClass = baseArmorClass
    }
}
