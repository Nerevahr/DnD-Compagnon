//
//  WeaponType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 14/06/2026.
//

import Foundation

/// Catégories d'armes D&D 5e
enum WeaponType: String, Codable, CaseIterable {
    case simpleMelee = "Arme courante de corps à corps"
    case simpleRanged = "Arme courante à distance"
    case martialMelee = "Arme de guerre de corps à corps"
    case martialRanged = "Arme de guerre à distance"
    
    static let allValues = WeaponType.allCases.map { $0.rawValue }
}
