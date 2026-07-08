//
//  SpellLevelSection.swift
//  DnDCompagnon
//

import SwiftUI

struct SpellLevelSection: View {
    let level: Int
    let spells: [Spell]
    let onDelete: (IndexSet) -> Void

    private var levelHeader: String {
        level == 0 ? "Tours de magie" : "Niveau \(level)"
    }

    var body: some View {
        Section(header: Text(levelHeader)) {
            ForEach(spells) { spell in
                NavigationLink {
                    SpellDetailView(spell: spell)
                } label: {
                    SpellRow(spell: spell)
                }
            }
            .onDelete(perform: onDelete)
        }
    }
}
