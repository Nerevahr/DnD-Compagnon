//
//  Race.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


import Foundation
import SwiftData

@Model
final class Race {
    var name: String
    
    /// Aptitudes raciales avec leur description
    var abilities: [RaceAbility]

    /// Vitesse de déplacement en pieds (optionnel)
    var speed: Int?
    
    /// Taille par défaut (Petit, Moyen, etc.)
    var defaultSize: String
    
    init(
        name: String,
        abilities: [RaceAbility] = [],
        speed: Int? = nil,
        defaultSize: String = "Moyen"
    ) {
        self.name = name
        self.abilities = abilities
        self.speed = speed
        self.defaultSize = defaultSize
    }
}

/// Structure pour représenter une aptitude raciale
struct RaceAbility: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var description: String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}