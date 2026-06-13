//
//  DnDClass.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

@Model
final class DnDClass {
    var timestamp: Date
    var name: String
    var descriptionClass: String
    var abilities: [ClassAbility]
    var masteredStats: [String]
    var spellcastingAbility: String
    var masteredSkills: [String]
    
    init(
        timestamp: Date = Date(),
        name: String,
        descriptionClass: String = "",
        abilities: [ClassAbility] = [],
        masteredStats: [String] = [],
        spellcastingAbility: String = "",
        masteredSkills: [String] = []
    ) {
        self.timestamp = timestamp
        self.name = name
        self.descriptionClass = descriptionClass
        self.abilities = abilities
        self.masteredStats = masteredStats
        self.spellcastingAbility = spellcastingAbility
        self.masteredSkills = masteredSkills
    }
}

// MARK: - Helpers

extension DnDClass {
    /// Helper pour grouper les aptitudes par niveau
    var abilitiesByLevel: [Int: [ClassAbility]] {
        Dictionary(grouping: abilities, by: { $0.level })
    }
    
    /// Retourne les noms des aptitudes pour un niveau donné
    func abilityNames(at level: Int) -> [String] {
        abilities.filter { $0.level == level }.map { $0.name }
    }
}
