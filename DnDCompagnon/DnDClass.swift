//
//  DnDClass.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//


import Foundation
import SwiftData

// Structure pour représenter une aptitude de classe
struct ClassAbility: Codable, Hashable {
    var level: Int
    var name: String
}

@Model
final class DnDClass {
    var timestamp: Date
    var name: String
    var descriptionClass: String
    
    // Liste d'aptitudes avec niveau et nom
    var abilities: [ClassAbility]
    
    // Statistiques maîtrisées (ex: "Force", "Constitution")
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
    
    // Helper pour grouper les aptitudes par niveau
    var abilitiesByLevel: [Int: [String]] {
        Dictionary(grouping: abilities, by: { $0.level })
            .mapValues { $0.map { $0.name } }
    }
}
