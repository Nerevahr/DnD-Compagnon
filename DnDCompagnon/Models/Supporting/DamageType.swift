//
//  DamageType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 14/06/2026.
//


import Foundation

/// Types de dégâts D&D 5e
enum DamageType: String, Codable, CaseIterable {
    case slashing = "Tranchant"
    case piercing = "Perforant"
    case bludgeoning = "Contondant"
    case fire = "Feu"
    case cold = "Froid"
    case lightning = "Foudre"
    case thunder = "Tonnerre"
    case acid = "Acide"
    case poison = "Poison"
    case necrotic = "Nécrotique"
    case radiant = "Radiant"
    case psychic = "Psychique"
    case force = "Force"
    
    static let allValues = DamageType.allCases.map { $0.rawValue }
}
