//
//  PreparedSpellRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  PreparedSpellRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Ligne affichant un sort préparé
struct PreparedSpellRow: View {
    let spell: Spell
    let onRemove: () -> Void
    
    @State private var isShowingDetail = false
    
    var body: some View {
        Button(action: { isShowingDetail = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(spell.name)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(spell.ecole)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if spell.concentration {
                            Label("C", systemImage: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        
                        Text(spell.formattedComponents)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $isShowingDetail) {
            SpellDetailSheet(spell: spell)
        }
    }
}