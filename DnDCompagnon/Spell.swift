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
    var materialDescription: String // ⚠️ AJOUT : Description du composant matériel
    var dureeIncantation: String
    
    init(timestamp: Date, name: String, portee: String, ecole: String, componentV: Bool, componentS: Bool, componentM: Bool, materialDescription: String = "", dureeIncantation: String) {
        self.timestamp = timestamp
        self.name = name
        self.portee = portee
        self.ecole = ecole
        self.componentV = componentV
        self.componentS = componentS
        self.componentM = componentM
        self.materialDescription = materialDescription
        self.dureeIncantation = dureeIncantation
    }
    
    var formattedComponents: String {
        var comps: [String] = []
        if componentV { comps.append("V") }
        if componentS { comps.append("S") }
        if componentM {
            // Si une description est renseignée, on l'affiche entre parenthèses
            if !materialDescription.isEmpty {
                comps.append("M (\(materialDescription))")
            } else {
                comps.append("M")
            }
        }
        return comps.isEmpty ? "Aucune" : comps.joined(separator: ", ")
    }
}
