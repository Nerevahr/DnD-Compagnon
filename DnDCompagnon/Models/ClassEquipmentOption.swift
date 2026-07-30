//
//  ClassEquipmentOption.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import Foundation
import SwiftData

@Model
final class ClassEquipmentOption {
    var goldPieces: Double
    @Relationship(deleteRule: .nullify) var items: [Item]
    var dndClass: DnDClass?

    init(
        items: [Item] = [],
        goldPieces: Double = 0,
        dndClass: DnDClass? = nil
    ) {
        self.items = items
        self.goldPieces = goldPieces
        self.dndClass = dndClass
    }
}
