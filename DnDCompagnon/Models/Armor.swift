//
//  Weapon.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 16/06/2026.
//

import Foundation
import SwiftData

@Model
final class Armor {
    var id = UUID()
    var name: String
    var armorDescription: String
    var imageData: Data?
    var armorCategory: ArmorCategory?
    var baseArmorClass: Int?
    
    init(
        name: String,
        armorDescription: String = "",
        type: ItemType = .objet,
        imageData: Data? = nil,
        armorCategory: ArmorCategory? = nil,
        baseArmorClass: Int? = nil,
    ) {
        self.name = name
        self.armorDescription = armorDescription
        self.imageData = imageData
        self.armorCategory = armorCategory
        self.baseArmorClass = baseArmorClass
    }
}
