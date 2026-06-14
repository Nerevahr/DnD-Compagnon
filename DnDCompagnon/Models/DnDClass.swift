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
    
    // Nouveau : Table des emplacements de sorts
    // Dictionnaire : [niveau de personnage: [niveau de sort: nombre d'emplacements]]
    // Exemple: [1: [1: 2], 2: [1: 3], 3: [1: 4, 2: 2]]
    var spellSlots: [Int: [Int: Int]]
    
    init(
        timestamp: Date = Date(),
        name: String,
        descriptionClass: String = "",
        abilities: [ClassAbility] = [],
        masteredStats: [String] = [],
        spellcastingAbility: String = "",
        masteredSkills: [String] = [],
        spellSlots: [Int: [Int: Int]] = [:] // Nouveau paramètre
    ) {
        self.timestamp = timestamp
        self.name = name
        self.descriptionClass = descriptionClass
        self.abilities = abilities
        self.masteredStats = masteredStats
        self.spellcastingAbility = spellcastingAbility
        self.masteredSkills = masteredSkills
        self.spellSlots = spellSlots
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
    
    /// Retourne les emplacements de sorts disponibles pour un niveau de personnage donné
    /// - Parameter characterLevel: Le niveau du personnage
    /// - Returns: Dictionnaire [niveau de sort: nombre d'emplacements]
    func spellSlots(at characterLevel: Int) -> [Int: Int] {
        return spellSlots[characterLevel] ?? [:]
    }
    
    /// Retourne le nombre d'emplacements pour un niveau de sort spécifique
    /// - Parameters:
    ///   - characterLevel: Le niveau du personnage
    ///   - spellLevel: Le niveau du sort (1-9)
    /// - Returns: Le nombre d'emplacements disponibles
    func spellSlotCount(characterLevel: Int, spellLevel: Int) -> Int {
        return spellSlots[characterLevel]?[spellLevel] ?? 0
    }
}
