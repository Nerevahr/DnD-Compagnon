//
//  SpellRow.swift
//  DnDCompagnon
//

import SwiftUI

struct SpellRow: View {
    let spell: Spell

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(spell.name).font(.headline)
                Spacer()
                if spell.concentration {
                    Image(systemName: "c.circle.fill")
                        .foregroundColor(.orange)
                        .help("Concentration")
                }
            }
            HStack {
                Text("• \(spell.portee)").font(.subheadline).foregroundColor(.gray)
                Text("• \(spell.formattedComponents)").font(.subheadline).foregroundColor(.gray)
            }
        }
    }
}
