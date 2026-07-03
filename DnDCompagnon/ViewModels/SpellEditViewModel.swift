//
//  SpellEditViewModel.swift
//  DnDCompagnon
//

import Foundation

/// Etat et logique métier de l'édition d'un sort
@Observable
final class SpellEditViewModel {
    private let spell: Spell
    var editingClasses: Set<String>

    static let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    init(spell: Spell) {
        self.spell = spell
        self.editingClasses = Set(spell.classes)
    }

    var isValid: Bool {
        !spell.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func toggleClass(_ classe: String) {
        if editingClasses.contains(classe) {
            editingClasses.remove(classe)
        } else {
            editingClasses.insert(classe)
        }
    }

    func save() {
        spell.classes = Array(editingClasses).sorted()

        if !spell.componentM {
            spell.materialDescription = ""
        }
        if !spell.isOffensive {
            spell.damageAmount = nil
            spell.alternateDamageAmount = nil
            spell.requiresSavingThrow = false
            spell.savingThrowStat = nil
        }
        if !spell.requiresSavingThrow {
            spell.savingThrowStat = nil
        }
    }
}
