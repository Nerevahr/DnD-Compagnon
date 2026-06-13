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
    var niveau: Int              // 0 = tour de magie, 1-9 = niveau du sort
    var classes: [String]        // Classes pouvant utiliser ce sort
    var concentration: Bool      // Nécessite la concentration
    var descriptionSort: String  // Description / effets du sort
    // propriétés avec Nouvelles valeurs par défaut
    var isOffensive: Bool = false
    var requiresSavingThrow: Bool = false
    var savingThrowStat: String? = nil  // Optionnel = automatiquement nil
    var damageAmount: String? = nil
    var alternateDamageAmount: String? = nil      // Montant des dégâts alternatif (ex: succès partiel)

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
            descriptionSort: String = "",
            isOffensive: Bool = false,
            requiresSavingThrow: Bool = false,
            savingThrowStat: String? = nil,
            damageAmount: String? = nil,
            alternateDamageAmount: String? = nil
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
            self.isOffensive = isOffensive
            self.requiresSavingThrow = requiresSavingThrow
            self.savingThrowStat = savingThrowStat
            self.damageAmount = damageAmount
            self.alternateDamageAmount = alternateDamageAmount
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
    
    /// Libellé formaté des informations offensives
    var offensiveInfo: String {
        guard isOffensive else { return "Non offensif" }
        
        var info: [String] = []
        
        if let damage = damageAmount {
            info.append("Dégâts : \(damage)")
        }
        
        if requiresSavingThrow, let stat = savingThrowStat {
            info.append("JdS : \(stat)")
        }
        
        if let altDamage = alternateDamageAmount {
            info.append("Alt : \(altDamage)")
        }
        
        return info.isEmpty ? "Offensif" : info.joined(separator: " | ")
    }
}

// MARK: - Classes D&D disponibles
extension Spell {
    static let classesDnD = [
        "Barbare", "Barde", "Clerc", "Druide",
        "Ensorceleur", "Magicien", "Moine", "Paladin",
        "Ranger", "Roublard", "Sorcier", "Artificier"
    ]
    static let savingThrowStats = [
        "Force", "Dextérité", "Constitution",
        "Intelligence", "Sagesse", "Charisme"
    ]
}

// MARK: - Import JSON
struct SpellJSON: Codable {
    var name: String
    var portee: String
    var ecole: String
    var componentV: Bool
    var componentS: Bool
    var componentM: Bool
    var materialDescription: String?
    var dureeIncantation: String
    var duree: String
    var niveau: Int
    var classes: [String]
    var concentration: Bool
    var descriptionSort: String?
    
    // Nouvelles propriétés
    var isOffensive: Bool?
    var requiresSavingThrow: Bool?
    var savingThrowStat: String?
    var damageAmount: String?
    var alternateDamageAmount: String?
    
    func toSpell() -> Spell {
        Spell(
            timestamp: Date(),
            name: name,
            portee: portee,
            ecole: ecole,
            componentV: componentV,
            componentS: componentS,
            componentM: componentM,
            materialDescription: materialDescription ?? "",
            dureeIncantation: dureeIncantation,
            duree: duree,
            niveau: niveau,
            classes: classes,
            concentration: concentration,
            descriptionSort: descriptionSort ?? "",
            isOffensive: isOffensive ?? false,
            requiresSavingThrow: requiresSavingThrow ?? false,
            savingThrowStat: savingThrowStat,
            damageAmount: damageAmount,
            alternateDamageAmount: alternateDamageAmount
        )
    }
}
