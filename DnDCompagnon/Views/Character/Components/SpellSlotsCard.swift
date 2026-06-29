//
//  SpellSlotsCard.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/06/2026.
//

import SwiftUI

/// Carte affichant les emplacements de sorts disponibles et utilisés
struct SpellSlotsCard: View {
    @Bindable var character: Character
    let preparedSpellsByLevel: [Int: [PreparedSpell]]  // ✅ Changé de [Spell] à [PreparedSpell]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Emplacements de sorts")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Bouton pour reset (restaure tous les emplacements)
                Button(action: {
                    withAnimation {
                        character.restoreAllSpellSlots()
                    }
                }) {
                    Label("reset", systemImage: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            
            ForEach(1...9, id: \.self) { level in
                let maxSlots = character.spellSlotCount(for: level)
                
                if maxSlots > 0 {
                    SpellSlotLevelRow(
                        character: character,
                        level: level,
                        maxSlots: maxSlots
                    )
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }
}

/// Ligne pour un niveau de sort avec ses emplacements
struct SpellSlotLevelRow: View {
    @Bindable var character: Character
    let level: Int
    let maxSlots: Int
    
    var usedSlots: Int {
        character.usedSpellSlotCount(for: level)
    }
    
    var remainingSlots: Int {
        character.remainingSpellSlots(for: level)
    }
    
    var body: some View {
        HStack {
            Text("Niveau \(level)")
                .font(.body)
                .foregroundColor(.primary)
                .frame(width: 70, alignment: .leading)
            
            // Carrés pour visualiser les emplacements
            HStack(spacing: 4) {
                ForEach(0..<maxSlots, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            toggleSlot(at: index)
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index < usedSlots ? Color.gray.opacity(0.3) : Color.cyan)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.cyan.opacity(0.7), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
            
            // Compteur textuel
            Text("\(remainingSlots)/\(maxSlots)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(remainingSlots == 0 ? .red : .secondary)
                .frame(minWidth: 40, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
    
    private func toggleSlot(at index: Int) {
        if index < usedSlots {
            // Clic sur un emplacement utilisé -> restaurer
            character.restoreSpellSlot(level: level)
        } else if index == usedSlots && usedSlots < maxSlots {
            // Clic sur le prochain emplacement disponible -> utiliser
            character.useSpellSlot(level: level)
        }
    }
}
