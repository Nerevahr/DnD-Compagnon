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
    
    // Propriétés spécifiques aux armes
    var weaponType: WeaponType?        // Type d'arme (épée longue, arc court, etc.)
    var damageDice: String?            // Dés de dégâts (ex: "1d8", "2d6", "1d4")
    var damageType: DamageType?        // Type de dégâts (tranchant, perforant, etc.)
    
    init(
        timestamp: Date = Date(),
        name: String,
        itemDescription: String = "",
        type: ItemType = .objet,
        imageData: Data? = nil,
        armorCategory: ArmorCategory? = nil,
        baseArmorClass: Int? = nil,
        weaponType: WeaponType? = nil,
        damageDice: String? = nil,
        damageType: DamageType? = nil
    ) {
        self.timestamp = timestamp
        self.name = name
        self.itemDescription = itemDescription
        self.type = type
        self.imageData = imageData
        self.armorCategory = armorCategory
        self.baseArmorClass = baseArmorClass
        self.weaponType = weaponType
        self.damageDice = damageDice
        self.damageType = damageType
    }
}
