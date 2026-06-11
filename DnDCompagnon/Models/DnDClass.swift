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
    
    // Liste d'aptitudes avec niveau et nom
    var abilities: [ClassAbility]
    
    // Statistiques maîtrisées pour jets de sauvegarde (ex: "Force", "Constitution")
    var masteredStats: [String]
    
    // Caractéristique d'incantation (ex: "Intelligence", "Sagesse", "Charisme", ou vide si pas de magie)
    var spellcastingAbility: String
    
    // Compétences maîtrisées
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
