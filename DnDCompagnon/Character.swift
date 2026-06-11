//
//  Character.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

// Structure pour les compétences D&D 5e
struct DnDSkill: Codable, Hashable {
    let name: String
    let baseStat: String // La caractéristique associée
}

@Model
final class Character {
    var timestamp: Date
    var name: String
    var level: Int
    
    // Relation vers la classe
    var dndClass: DnDClass?
    var race: String
    var origin: String // origine
    
    // Stats de base (scores de caractéristiques)
    var strength: Int
    var dexterity: Int
    var constitution: Int
    var intelligence: Int
    var wisdom: Int
    var charisma: Int
    
    // Compétences maîtrisées par le personnage (liste des noms)
    var proficientSkills: [String]
    
    // Sorts préparés (relation vers les sorts)
    @Relationship(deleteRule: .nullify) var preparedSpells: [Spell]
    
    // Liste de toutes les compétences disponibles (static)
    static let allSkills: [DnDSkill] = [
        DnDSkill(name: "Acrobaties", baseStat: "Dextérité"),
        DnDSkill(name: "Arcanes", baseStat: "Intelligence"),
        DnDSkill(name: "Athlétisme", baseStat: "Force"),
        DnDSkill(name: "Discrétion", baseStat: "Dextérité"),
        DnDSkill(name: "Dressage", baseStat: "Sagesse"),
        DnDSkill(name: "Escamotage", baseStat: "Dextérité"),
        DnDSkill(name: "Histoire", baseStat: "Intelligence"),
        DnDSkill(name: "Intimidation", baseStat: "Charisme"),
        DnDSkill(name: "Investigation", baseStat: "Intelligence"),
        DnDSkill(name: "Médecine", baseStat: "Sagesse"),
        DnDSkill(name: "Nature", baseStat: "Intelligence"),
        DnDSkill(name: "Perception", baseStat: "Sagesse"),
        DnDSkill(name: "Perspicacité", baseStat: "Sagesse"),
        DnDSkill(name: "Persuasion", baseStat: "Charisme"),
        DnDSkill(name: "Religion", baseStat: "Intelligence"),
        DnDSkill(name: "Représentation", baseStat: "Charisme"),
        DnDSkill(name: "Survie", baseStat: "Sagesse"),
        DnDSkill(name: "Tromperie", baseStat: "Charisme")
    ]
    
    // Modificateurs calculés
    var strengthModifier: Int {
        (strength - 10) / 2
    }
    var dexterityModifier: Int {
        (dexterity - 10) / 2
    }
    var constitutionModifier: Int {
        (constitution - 10) / 2
    }
    var intelligenceModifier: Int {
        (intelligence - 10) / 2
    }
    var wisdomModifier: Int {
        (wisdom - 10) / 2
    }
    var charismaModifier: Int {
        (charisma - 10) / 2
    }
    
    // Bonus de maîtrise basé sur le niveau
    var proficiencyBonus: Int {
        2 + (level - 1) / 4
    }
    
    // Méthode pour calculer un jet de sauvegarde
    func savingThrow(for stat: String) -> Int {
        let modifier = getModifier(for: stat)
        let isProficient = dndClass?.masteredStats.contains(stat) ?? false
        return modifier + (isProficient ? proficiencyBonus : 0)
    }
    
    // Méthode pour calculer le modificateur d'une compétence
    func skillModifier(for skill: DnDSkill) -> Int {
        let statModifier = getModifier(for: skill.baseStat)
        let isProficient = proficientSkills.contains(skill.name)
        return statModifier + (isProficient ? proficiencyBonus : 0)
    }
    
    // Méthode pour obtenir le modificateur d'une stat
    func getModifier(for stat: String) -> Int {
        switch stat {
        case "Force": return strengthModifier
        case "Dextérité": return dexterityModifier
        case "Constitution": return constitutionModifier
        case "Intelligence": return intelligenceModifier
        case "Sagesse": return wisdomModifier
        case "Charisme": return charismaModifier
        default: return 0
        }
    }
    
    init(
        timestamp: Date = Date(),
        name: String,
        level: Int = 1,
        dndClass: DnDClass? = nil,
        race: String = "",
        origin: String = "",
        strength: Int = 10,
        dexterity: Int = 10,
        constitution: Int = 10,
        intelligence: Int = 10,
        wisdom: Int = 10,
        charisma: Int = 10,
        proficientSkills: [String] = [],
        preparedSpells: [Spell] = []
    ) {
        self.timestamp = timestamp
        self.name = name
        self.level = level
        self.dndClass = dndClass
        self.race = race
        self.origin = origin
        self.strength = strength
        self.dexterity = dexterity
        self.constitution = constitution
        self.intelligence = intelligence
        self.wisdom = wisdom
        self.charisma = charisma
        self.proficientSkills = proficientSkills
        self.preparedSpells = preparedSpells
    }
}
