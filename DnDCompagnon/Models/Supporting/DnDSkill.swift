//
//  DnDSkill.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import Foundation

/// Structure pour les compétences D&D 5e
struct DnDSkill: Codable, Hashable, Identifiable {
    var id = UUID()
    let name: String
    let baseStat: String // La caractéristique associée
    
    /// Liste complète des 18 compétences de D&D 5e
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
        DnDSkill(name: "Intuition", baseStat: "Sagesse"),
        DnDSkill(name: "Persuasion", baseStat: "Charisme"),
        DnDSkill(name: "Religion", baseStat: "Intelligence"),
        DnDSkill(name: "Représentation", baseStat: "Charisme"),
        DnDSkill(name: "Survie", baseStat: "Sagesse"),
        DnDSkill(name: "Tromperie", baseStat: "Charisme")
    ]
}
