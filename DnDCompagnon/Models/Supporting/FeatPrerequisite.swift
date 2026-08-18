//
//  FeatPrerequisite.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 18/08/2026.
//

import Foundation

/// Type d'un prérequis de don
enum PrerequisiteType: String, Codable, CaseIterable, Hashable {
    case niveau
    case caracteristique
    case autre
}

/// Représente un prérequis nécessaire pour choisir un don (ex: niveau, caractéristique, capacité...)
///
/// Le format de `value` dépend du `type` :
/// - `.niveau` : le niveau minimum requis, ex. `"4"`
/// - `.caracteristique` : une liste de caractéristiques (séparées par des virgules) dont l'une au
///   moins doit atteindre le seuil indiqué, ex. `"Force,Dextérité:13"`
/// - `.autre` : un texte libre décrivant un prérequis non vérifiable automatiquement
///   (capacité de classe, formation à une armure, etc.), ex. `"Capacité Style de combat"`
struct FeatPrerequisite: Codable, Hashable {
    var type: PrerequisiteType
    var value: String

    /// Décompose la valeur d'un prérequis de caractéristique en liste de caractéristiques et seuil
    var parsedCaracteristique: (stats: [String], threshold: Int)? {
        guard type == .caracteristique else { return nil }
        let parts = value.split(separator: ":")
        guard parts.count == 2, let threshold = Int(parts[1]) else { return nil }
        let stats = parts[0].split(separator: ",").map(String.init)
        return (stats, threshold)
    }

    /// Texte lisible du prérequis, tel qu'affiché dans la vue de détail d'un don
    var displayText: String {
        switch type {
        case .niveau:
            return "Niveau \(value) ou supérieur"
        case .caracteristique:
            guard let parsed = parsedCaracteristique else { return value }
            return "\(parsed.stats.joined(separator: " ou ")) \(parsed.threshold) ou plus"
        case .autre:
            return value
        }
    }

    /// Vérifie si un personnage remplit ce prérequis.
    /// Les prérequis de type `.autre` (capacité de classe, formation...) ne sont pas
    /// représentés dans le modèle de personnage : ils sont donc considérés comme remplis.
    func isMet(by character: Character) -> Bool {
        switch type {
        case .niveau:
            guard let requiredLevel = Int(value) else { return true }
            return character.level >= requiredLevel
        case .caracteristique:
            guard let parsed = parsedCaracteristique else { return true }
            return parsed.stats.contains { character.getScore(for: $0) >= parsed.threshold }
        case .autre:
            return true
        }
    }
}
