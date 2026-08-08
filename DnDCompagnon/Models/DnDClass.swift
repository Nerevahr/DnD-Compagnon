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

    /// Dé de vie de la classe (d4, d6, d8, d10, d12 ou d20).
    /// Détermine le maximum du résultat pouvant être obtenu lors du gain de PV à la montée de niveau.
    var hitDie: HitDie = HitDie.d8

    // Nouveau : Table des emplacements de sorts
    // Dictionnaire : [niveau de personnage: [niveau de sort: nombre d'emplacements]]
    // Exemple: [1: [1: 2], 2: [1: 3], 3: [1: 4, 2: 2]]
    var spellSlots: [Int: [Int: Int]]

    @Relationship(deleteRule: .cascade, inverse: \ClassEquipmentOption.dndClass)
    var equipmentOptions: [ClassEquipmentOption] = []

    init(
        timestamp: Date = Date(),
        name: String,
        descriptionClass: String = "",
        abilities: [ClassAbility] = [],
        masteredStats: [String] = [],
        spellcastingAbility: String = "",
        masteredSkills: [String] = [],
        hitDie: HitDie = .d8,
        spellSlots: [Int: [Int: Int]] = [:], // Nouveau paramètre
        equipmentOptions: [ClassEquipmentOption] = []
    ) {
        self.timestamp = timestamp
        self.name = name
        self.descriptionClass = descriptionClass
        self.abilities = abilities
        self.masteredStats = masteredStats
        self.spellcastingAbility = spellcastingAbility
        self.masteredSkills = masteredSkills
        self.hitDie = hitDie
        self.spellSlots = spellSlots
        self.equipmentOptions = equipmentOptions
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

    /// Vérifie si cette classe possède l'aptitude "Ordre divin" (Clerc niv. 1)
    var hasOrdreDivin: Bool {
        abilities.contains { $0.name == "Ordre divin" }
    }

    /// Vérifie si cette classe possède l'aptitude "Sorts"
    var hasSorts: Bool {
        abilities.contains { $0.name == "Sorts" }
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
