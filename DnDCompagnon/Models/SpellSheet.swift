//
//  SpellSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import Foundation
import SwiftData

@Model
final class SpellSheet {
    var timestamp: Date
    var title: String

    @Relationship(deleteRule: .cascade) var preparedSpells: [PreparedSpell]

    init(
        timestamp: Date = Date(),
        title: String,
        preparedSpells: [PreparedSpell] = []
    ) {
        self.timestamp = timestamp
        self.title = title
        self.preparedSpells = preparedSpells
    }
}

// MARK: - Prepared Spells Management

extension SpellSheet {
    /// Retourne les sorts de la fiche groupés par niveau
    var preparedSpellsByLevel: [Int: [PreparedSpell]] {
        let validSpells = preparedSpells.filter { $0.baseSpell != nil }
        return Dictionary(grouping: validSpells) { preparedSpell in
            preparedSpell.baseSpell?.niveau ?? 0
        }
    }

    /// Ajoute un sort à la fiche
    func addSpell(_ spell: Spell) {
        let preparedSpell = PreparedSpell(baseSpell: spell)
        preparedSpells.append(preparedSpell)
    }

    /// Retire un sort de la fiche
    func removeSpell(_ preparedSpell: PreparedSpell) {
        if let index = preparedSpells.firstIndex(of: preparedSpell) {
            preparedSpells.remove(at: index)
        }
    }

    /// Vérifie si un sort est déjà présent dans la fiche
    func isSpellAdded(_ spell: Spell) -> Bool {
        preparedSpells.contains { $0.baseSpell?.persistentModelID == spell.persistentModelID }
    }
}
