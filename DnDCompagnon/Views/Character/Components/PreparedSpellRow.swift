//
//  PreparedSpellRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

struct PreparedSpellRow: View {
    let preparedSpell: PreparedSpell
    
    @State private var isShowingDetail = false
    @State private var isShowingEdit = false
    
    private var spell: Spell? {
        preparedSpell.baseSpell
    }
    
    var body: some View {
        Button(action: { isShowingDetail = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(spell?.name ?? "Sort inconnu")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        // Indicateur de personnalisation
                        if preparedSpell.hasCustomizations {
                            Image(systemName: "pencil.circle")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Text(spell?.dureeIncantation ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if spell?.concentration ?? false {
                            Label("C", systemImage: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        
                        Text(spell?.formattedComponents ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Utilise les valeurs personnalisées si disponibles
                        if spell?.isOffensive ?? false, let damage = preparedSpell.damageAmount {
                            Text(damage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(6)
                        }
                        
                        if spell?.isOffensive ?? false, let altDamage = preparedSpell.alternateDamageAmount {
                            Text(altDamage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background((Color.red).opacity(0.7))
                                .cornerRadius(6)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .contextMenu {  // ✅ Menu contextuel (longue pression)
            Button {
                isShowingEdit = true
            } label: {
                Label("Personnaliser", systemImage: "pencil")
            }
            
            if spell != nil {
                Button {
                    isShowingDetail = true
                } label: {
                    Label("Voir les détails", systemImage: "info.circle")
                }
            }
            
            if preparedSpell.hasCustomizations {
                Button(role: .destructive) {
                    resetCustomizations()
                } label: {
                    Label("Réinitialiser", systemImage: "arrow.counterclockwise")
                }
            }
        }
        .sheet(isPresented: $isShowingDetail) {
            if let spell = spell {
                SpellDetailSheet(spell: spell)
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            PreparedSpellEditView(preparedSpell: preparedSpell)
        }
    }
    
    private func resetCustomizations() {
        withAnimation {
            preparedSpell.customDamageAmount = nil
            preparedSpell.customAlternateDamageAmount = nil
            preparedSpell.customSavingThrowStat = nil
            preparedSpell.customDescription = nil
            preparedSpell.notes = nil
        }
    }
}
