//
//  SpellsPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  SpellsPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

/// Page affichant les sorts préparés du personnage
struct SpellsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSpells: [Spell]
    
    @Bindable var character: Character
    @State private var isShowingSpellPicker = false
    
    var availableSpells: [Spell] {
        guard let className = character.dndClass?.name else { return [] }
        return allSpells.filter { spell in
            spell.classes.contains(className) &&
            !character.preparedSpells.contains(where: { $0.id == spell.id })
        }
    }
    
    var spellsByLevel: [Int: [Spell]] {
        Dictionary(grouping: character.preparedSpells, by: { $0.niveau })
            .mapValues { $0.sorted { $0.name < $1.name } }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Sorts préparés")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { isShowingSpellPicker = true }) {
                        Label("Ajouter", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                }
                
                // Section caractéristique d'incantation
                if let dndClass = character.dndClass, !dndClass.spellcastingAbility.isEmpty {
                    SpellcastingStatsCard(character: character, spellcastingAbility: dndClass.spellcastingAbility)
                }
                
                // Liste des sorts préparés
                if character.preparedSpells.isEmpty {
                    EmptySpellsView()
                } else {
                    PreparedSpellsList(spellsByLevel: spellsByLevel, onRemove: removeSpell)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingSpellPicker) {
            SpellPickerView(character: character, availableSpells: availableSpells)
        }
    }
    
    private func removeSpell(_ spell: Spell) {
        withAnimation {
            if let index = character.preparedSpells.firstIndex(where: { $0.id == spell.id }) {
                character.preparedSpells.remove(at: index)
            }
        }
    }
}

// MARK: - Spellcasting Stats Card

/// Carte affichant les statistiques d'incantation
struct SpellcastingStatsCard: View {
    let character: Character
    let spellcastingAbility: String
    
    var body: some View {
        VStack(spacing: 12) {
            // Caractéristique d'incantation
            HStack {
                Text("Caractéristique d'incantation")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(spellcastingAbility)
                    .font(.headline)
                    .foregroundColor(.purple)
            }
            
            Divider()
            
            // DD et Bonus d'attaque
            HStack(spacing: 20) {
                // DD des sorts
                if let spellDC = character.spellSaveDC {
                    VStack(spacing: 4) {
                        Text("DD des sorts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(spellDC)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Divider()
                    .frame(height: 40)
                
                // Bonus d'attaque
                if let attackBonus = character.spellAttackBonusFormatted {
                    VStack(spacing: 4) {
                        Text("Bonus d'attaque")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(attackBonus)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Empty Spells View

/// Vue affichée quand aucun sort n'est préparé
struct EmptySpellsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.purple.opacity(0.3))
            Text("Aucun sort préparé")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Appuyez sur + pour ajouter des sorts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Prepared Spells List

/// Liste des sorts préparés groupés par niveau
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