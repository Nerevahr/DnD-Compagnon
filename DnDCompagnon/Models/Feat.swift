//
//  Feat.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftData

/// Modèle représentant un don (feat) en D&D 5e
@Model
final class Feat: Identifiable {
    var id: UUID
    var name: String
    var type: FeatType
    var featDescription: String
    var prerequisites: [FeatPrerequisite]

    init(
        id: UUID = UUID(),
        name: String,
        type: FeatType,
        featDescription: String,
        prerequisites: [FeatPrerequisite] = [],
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.featDescription = featDescription
        self.prerequisites = prerequisites
    }
}
