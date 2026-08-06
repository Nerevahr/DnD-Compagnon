//
//  PreparedSpell.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 19/06/2026.
//


//
//  PreparedSpell.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 19/06/2026.
//

import Foundation
import SwiftData

@Model
final class PreparedSpell {
    var timestamp: Date
    
    // Relation vers le sort de base
    @Relationship(deleteRule: .nullify) var baseSpell: Spell?
    
    // Valeurs personnalisées (optionnelles, si nil utilise les valeurs du sort de base)
    var customDamageAmount: String?
    var customAlternateDamageAmount: String?
    var customSavingThrowStat: String?
    var customDescription: String?
    
    // Notes personnelles pour ce sort préparé
    var notes: String?

    // Sort toujours préparé (ex. octroyé par un don comme "Initié à la magie"), non retirable
    var isAlwaysPrepared: Bool = false

    // Origine du sort préparé (classe, don, aptitude)
    var source: PreparedSpellSource = PreparedSpellSource.classe

    // Si source == .don : le don précis qui a octroyé ce sort
    @Relationship(deleteRule: .nullify) var sourceFeat: Feat?

    // Si source == .aptitude : le nom de l'aptitude de classe qui a octroyé ce sort
    var sourceAbilityName: String?

    init(
        timestamp: Date = Date(),
        baseSpell: Spell? = nil,
        customDamageAmount: String? = nil,
        customAlternateDamageAmount: String? = nil,
        customSavingThrowStat: String? = nil,
        customDescription: String? = nil,
        notes: String? = nil,
        isAlwaysPrepared: Bool = false,
        source: PreparedSpellSource = .classe,
        sourceFeat: Feat? = nil,
        sourceAbilityName: String? = nil
    ) {
        self.timestamp = timestamp
        self.baseSpell = baseSpell
        self.customDamageAmount = customDamageAmount
        self.customAlternateDamageAmount = customAlternateDamageAmount
        self.customSavingThrowStat = customSavingThrowStat
        self.customDescription = customDescription
        self.notes = notes
        self.isAlwaysPrepared = isAlwaysPrepared
        self.source = source
        self.sourceFeat = sourceFeat
        self.sourceAbilityName = sourceAbilityName
    }
}

// MARK: - Helpers

extension PreparedSpell {
    /// Retourne le montant de dégâts à utiliser (personnalisé ou par défaut)
    var damageAmount: String? {
        customDamageAmount ?? baseSpell?.damageAmount
    }
    
    /// Retourne le montant de dégâts alternatif à utiliser
    var alternateDamageAmount: String? {
        customAlternateDamageAmount ?? baseSpell?.alternateDamageAmount
    }
    
    /// Retourne la stat de JdS à utiliser
    var savingThrowStat: String? {
        customSavingThrowStat ?? baseSpell?.savingThrowStat
    }
    
    /// Retourne la description à utiliser
    var description: String {
        customDescription ?? baseSpell?.descriptionSort ?? ""
    }
    
    /// Indique si des personnalisations ont été appliquées
    var hasCustomizations: Bool {
        customDamageAmount != nil ||
        customAlternateDamageAmount != nil ||
        customSavingThrowStat != nil ||
        customDescription != nil ||
        notes != nil
    }

    /// Texte affichable décrivant l'origine du sort (ex. "Don — Initié à la magie")
    var sourceDisplayName: String {
        switch source {
        case .classe:
            return source.displayName
        case .don:
            if let featName = sourceFeat?.name {
                return "\(source.displayName) — \(featName)"
            }
            return source.displayName
        case .aptitude:
            if let abilityName = sourceAbilityName {
                return "\(source.displayName) — \(abilityName)"
            }
            return source.displayName
        }
    }
}