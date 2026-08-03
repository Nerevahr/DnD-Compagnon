//
//  CharacterRulesEngine.swift
//  DnDCompagnon
//

import Foundation
import SwiftData

/// Centralise les règles qui traduisent un Don ou une Aptitude en effet sur un Character :
/// les noms de référence, les calculs de bonus, et les mutations appliquées lors de la
/// création ou de la montée de niveau d'un personnage.
enum CharacterRulesEngine {

    enum AbilityName {
        static let dwarvenToughness = "Ténacité naine"
        static let ordreDivin = "Ordre divin"
    }

    enum FeatName {
        static let magicInitiate = "Initié à la magie"
    }

    /// Bonus de points de vie octroyé par la race (ex : Ténacité naine)
    static func racialHPBonus(for race: Race?) -> Int {
        (race?.abilities.contains { $0.name == AbilityName.dwarvenToughness } ?? false) ? 1 : 0
    }

    /// Gain de PV lors d'une montée de niveau, en tenant compte des bonus raciaux
    static func levelUpHPGain(dieRoll: Int, constitutionModifier: Int, race: Race?) -> Int {
        max(1, dieRoll + constitutionModifier + racialHPBonus(for: race))
    }

    /// Applique le bonus du Thaumaturge (aptitude "Ordre divin" du Clerc)
    static func applyDivineOrder(to character: Character, dndClass: DnDClass?, choice: DivineOrderChoice) {
        guard let dndClass, dndClass.hasOrdreDivin, choice == .thaumaturge else { return }
        character.skillStatBonuses["Religion"] = "Sagesse"
        character.skillStatBonuses["Arcanes"] = "Sagesse"
    }

    /// Prépare les sorts octroyés par le don "Initié à la magie"
    static func applyMagicInitiate(
        to character: Character,
        background: Background?,
        cantripIDs: Set<PersistentIdentifier>,
        level1SpellID: PersistentIdentifier?,
        allSpells: [Spell]
    ) {
        guard let background, background.grantsMagicInitiate else { return }

        for cantripID in cantripIDs {
            if let spell = allSpells.first(where: { $0.id == cantripID }) {
                character.prepareSpell(spell)
            }
        }

        if let level1SpellID, let spell = allSpells.first(where: { $0.id == level1SpellID }) {
            character.prepareSpell(spell, isAlwaysPrepared: true)
        }
    }
}
