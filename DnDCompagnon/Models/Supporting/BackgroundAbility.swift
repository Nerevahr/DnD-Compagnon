//
//  BackgroundAbility.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//

import Foundation

/// Structure pour représenter l'aptitude unique d'une origine
struct BackgroundAbility: Codable, Hashable, Identifiable, Sendable {
    var id = UUID()
    var name: String
    var abilityDescription: String?

    init(name: String, abilityDescription: String? = nil) {
        self.name = name
        self.abilityDescription = abilityDescription
    }
}
