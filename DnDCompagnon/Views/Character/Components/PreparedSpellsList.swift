//
//  PreparedSpellsList.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/06/2026.
//

import SwiftUI

struct PreparedSpellsList: View {
    let spellsByLevel: [Int: [Spell]]
    let onRemove: (Spell) -> Void
    
    var body: some View {
        ForEach(spellsByLevel.keys.sorted(), id: \.self) { level in
            VStack(alignment: .leading, spacing: 8) {
                Text(level == 0 ? "Tours de magie" : "Niveau \(level)")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                ForEach(spellsByLevel[level] ?? [], id: \.id) { spell in
                    PreparedSpellRow(spell: spell) {
                        onRemove(spell)
                    }
                }
            }
            .padding()
            .background(Color.purple.opacity(0.05))
            .cornerRadius(10)
        }
    }
}
