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
    var feature: BackgroundAbility
    var toolProficiency: String
    @Relationship(deleteRule: .nullify) var originFeat: Feat?
    var defaultMagicClass: String?
    
    init(
        name: String,
        description: String = "",
        suggestedStats: [String] = [],
        feature: BackgroundAbility = BackgroundAbility(name: ""),
        toolProficiency: String = "",
        originFeat: Feat? = nil,
        defaultMagicClass: String? = nil
    ) {
        self.name = name
        self.backgroundDescription = description
        self.suggestedStats = suggestedStats
        self.feature = feature
        self.toolProficiency = toolProficiency
        self.originFeat = originFeat
        self.defaultMagicClass = defaultMagicClass
    }
    
    /// Vérifie si cette origine octroie le don "Initié à la magie"
    var grantsMagicInitiate: Bool {
        originFeat?.name == "Initié à la magie"
    }
    
    /// Classes de magie disponibles pour ce don (Druide, Magicien, Clerc)
    var magicInitiateClasses: [String] {
        ["Druide", "Magicien", "Clerc"]
    }
}
