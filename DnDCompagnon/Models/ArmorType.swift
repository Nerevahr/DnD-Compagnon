//
//  ArmorType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import Foundation

/// Catégorie d'armure selon D&D 5e
enum ArmorCategory: String, Codable, CaseIterable {
    case vetement = "Vêtement"      // CA 10 + Dex (sans armure)
    case legere = "Légère"          // CA de base + Dex complet
    case moyenne = "Moyenne"        // CA de base + Dex (max +2)
    case lourde = "Lourde"          // CA fixe (pas de bonus Dex)
    
    /// Description de comment fonctionne le calcul de CA
    var calculDescription: String {
        switch self {
        case .vetement:
            return "10 + Dextérité"
        case .legere:
            return "CA de base + Dextérité"
        case .moyenne:
            return "CA de base + Dextérité (max +2)"
        case .lourde:
            return "CA de base uniquement"
        }
    }
}
