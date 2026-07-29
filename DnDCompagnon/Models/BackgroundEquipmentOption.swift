//
//  BackgroundEquipmentOption.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 29/07/2026.
//

import Foundation
import SwiftData

@Model
final class BackgroundEquipmentOption {
    var goldPieces: Double
    @Relationship(deleteRule: .nullify) var items: [Item]
    var background: Background?

    init(
        items: [Item] = [],
        goldPieces: Double = 0,
        background: Background? = nil
    ) {
        self.items = items
        self.goldPieces = goldPieces
        self.background = background
    }
}
