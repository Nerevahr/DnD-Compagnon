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
                
                if let dndClass = character.dndClass, !dndClass.spellcastingAbility.isEmpty {
                    SpellcastingStatsCard(character: character, spellcastingAbility: dndClass.spellcastingAbility)
                    
                    // Carte des emplacements de sorts
                    SpellSlotsCard(character: character, preparedSpellsByLevel: spellsByLevel)
                }
                
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
