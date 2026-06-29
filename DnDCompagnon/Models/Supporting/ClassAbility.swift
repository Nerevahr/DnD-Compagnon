//
//  ClassAbility.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import Foundation

/// Structure pour représenter une aptitude (feature) de classe
struct ClassAbility: Codable, Hashable, Identifiable {
    var id = UUID()
    var level: Int
    var name: String
    var description: String? // Optionnel pour une description détaillée
    
    init(level: Int, name: String, description: String? = nil) {
        self.level = level
        self.name = name
        self.description = description
    }
}
