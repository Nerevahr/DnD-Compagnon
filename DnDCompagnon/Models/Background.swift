//
//  Background.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


import Foundation
import SwiftData

@Model
final class Background {
    var name: String
    var backgroundDescription: String
    var suggestedStats: [String]
    var toolProficiency: String
    var skillProficiencies: [String] = []
    @Relationship(deleteRule: .nullify) var originFeat: Feat?
    @Relationship(deleteRule: .cascade, inverse: \BackgroundEquipmentOption.background)
    var equipmentOptions: [BackgroundEquipmentOption] = []
    var defaultMagicClass: String?

    init(
        name: String,
        description: String = "",
        suggestedStats: [String] = [],
        toolProficiency: String = "",
        skillProficiencies: [String] = [],
        originFeat: Feat? = nil,
        equipmentOptions: [BackgroundEquipmentOption] = [],
        defaultMagicClass: String? = nil
    ) {
        self.name = name
        self.backgroundDescription = description
        self.suggestedStats = suggestedStats
        self.toolProficiency = toolProficiency
        self.skillProficiencies = skillProficiencies
        self.originFeat = originFeat
        self.equipmentOptions = equipmentOptions
        self.defaultMagicClass = defaultMagicClass
    }

    /// Vérifie si cette origine octroie le don "Initié à la magie"
    var grantsMagicInitiate: Bool {
        originFeat?.name == CharacterRulesEngine.FeatName.magicInitiate
    }

    /// Classes de magie disponibles pour ce don (Druide, Magicien, Clerc)
    var magicInitiateClasses: [String] {
        ["Druide", "Magicien", "Clerc"]
    }
}
