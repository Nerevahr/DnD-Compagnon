//
//  ItemType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  ItemType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import Foundation

/// Types d'objets disponibles
enum ItemType: String, Codable, CaseIterable {
    case objet = "Objet"
    case equipement = "Équipement"
    case armure = "Armure"
    case arme = "Arme"
    case bouclier = "Bouclier"
    case consommable = "Consommable"
    case tresor = "Trésor"
    case outilArtisan = "Outil d'artisan"
    
    /// Tous les noms bruts
    static let allValues = ItemType.allCases.map { $0.rawValue }
}