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
                    
                    HStack(spacing: 8) {
                        Text(spell.dureeIncantation)
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
                        
                        // Card rouge pour les sorts offensifs
                        if spell.isOffensive, let damage = spell.damageAmount {
                            Text(damage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(6)
                        }
                        
                        if spell.isOffensive, let altDamage = spell.alternateDamageAmount {
                            Text(altDamage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(6)
                        }
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
