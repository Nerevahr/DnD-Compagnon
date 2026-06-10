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
        timestamp: Date,
        name: String,
        itemDescription: String,
        type: ItemType,
        imageData: Data? = nil
    ) {
        self.timestamp = timestamp
        self.name = name
        self.itemDescription = itemDescription
        self.type = type
        self.imageData = imageData
    }
}

// MARK: - Types d'objets
enum ItemType: String, Codable, CaseIterable {
    case objet = "Objet"
    case equipement = "Équipement"
    case armure = "Armure"
    case arme = "Arme"
    case bouclier = "Bouclier"
    case consommable = "Consommable"
    
    static let allValues = ItemType.allCases.map { $0.rawValue }
}
