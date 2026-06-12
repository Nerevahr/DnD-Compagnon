//
//  ArmorType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import Foundation

/// Types d'armure selon D&D 5e
enum ArmorType: String, Codable, CaseIterable {
    // Armures légères (CA de base + Dex complet)
    case matelassee = "Matelassée"          // CA 11
    case cuir = "Cuir"                       // CA 11
    case cuirCloute = "Cuir clouté"          // CA 12
    
    // Armures moyennes (CA de base + Dex max +2)
    case peauDeBete = "Peau de bête"         // CA 12
    case chemiseDeMailles = "Chemise de mailles"  // CA 13
    case ecaillesDeDragon = "Écailles de dragon"  // CA 14
    case cuirasse = "Cuirasse"               // CA 14
    case demiplaque = "Demi-plaque"          // CA 15
    
    // Armures lourdes (CA fixe, pas de Dex)
    case broigne = "Broigne"                 // CA 14
    case cotte = "Cotte de mailles"          // CA 16
    case clibanion = "Clibanion"             // CA 17
    case harnois = "Harnois"                 // CA 18
    
    /// Catégorie de l'armure
    var category: ArmorCategory {
        switch self {
        case .matelassee, .cuir, .cuirCloute:
            return .legere
        case .peauDeBete, .chemiseDeMailles, .ecaillesDeDragon, .cuirasse, .demiplaque:
            return .moyenne
        case .broigne, .cotte, .clibanion, .harnois:
            return .lourde
        }
    }
    
    /// CA de base de l'armure
    var baseArmorClass: Int {
        switch self {
        case .matelassee, .cuir:
            return 11
        case .cuirCloute, .peauDeBete:
            return 12
        case .chemiseDeMailles:
            return 13
        case .ecaillesDeDragon, .cuirasse, .broigne:
            return 14
        case .demiplaque:
            return 15
        case .cotte:
            return 16
        case .clibanion:
            return 17
        case .harnois:
            return 18
        }
    }
}

/// Catégorie d'armure
enum ArmorCategory: String, Codable {
    case legere = "Légère"
    case moyenne = "Moyenne"
    case lourde = "Lourde"
}