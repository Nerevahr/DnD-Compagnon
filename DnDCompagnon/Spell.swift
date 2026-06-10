//
//  Spell.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

@Model
final class Spell {
    var timestamp: Date
    var name: String
    var portee: String
    var ecole: String
    var componentV: Bool
    var componentS: Bool
    var componentM: Bool
    var materialDescription: String
    var dureeIncantation: String
    var duree: String            // Durée de l'effet du sort

    // ⚠️ AJOUT
    var niveau: Int              // 0 = tour de magie, 1-9 = niveau du sort
    var classes: [String]        // Classes pouvant utiliser ce sort
    var concentration: Bool      // Nécessite la concentration
    var descriptionSort: String  // Description / effets du sort

    init(
        timestamp: Date,
        name: String,
        portee: String,
        ecole: String,
        componentV: Bool,
        componentS: Bool,
        componentM: Bool,
        materialDescription: String = "",
        dureeIncantation: String,
        duree: String = "Instantanée",
        niveau: Int = 1,
        classes: [String] = [],
        concentration: Bool = false,
        descriptionSort: String = ""
    ) {
        self.timestamp = timestamp
        self.name = name
        self.portee = portee
        self.ecole = ecole
        self.componentV = componentV
        self.componentS = componentS
        self.componentM = componentM
        self.materialDescription = materialDescription
        self.dureeIncantation = dureeIncantation
        self.duree = duree
        self.niveau = niveau
        self.classes = classes
        self.concentration = concentration
        self.descriptionSort = descriptionSort
    }

    /// Libellé du niveau affiché (tour de magie si 0)
    var niveauLabel: String {
        niveau == 0 ? "Tour de magie" : "Niveau \(niveau)"
    }

    /// Libellé des classes (ou "Aucune" si vide)
    var classesLabel: String {
        classes.isEmpty ? "Aucune" : classes.joined(separator: ", ")
    }

    var formattedComponents: String {
        var comps: [String] = []
        if componentV { comps.append("V") }
        if componentS { comps.append("S") }
        if componentM { comps.append("M") }
        return comps.isEmpty ? "Aucune" : comps.joined(separator: ", ")
    }
}

// MARK: - Classes D&D disponibles
extension Spell {
    static let classesDnD = [
        "Barbare", "Barde", "Clerc", "Druide",
        "Ensorceleur", "Magicien", "Moine", "Paladin",
        "Ranger", "Roublard", "Sorcier", "Artificier"
    ]
}
