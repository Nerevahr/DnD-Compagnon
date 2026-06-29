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
            !character.preparedSpells.contains(where: { $0.baseSpell?.persistentModelID == spell.persistentModelID })
        }
    }
    
    // Changé : maintenant retourne [Int: [PreparedSpell]]
    var spellsByLevel: [Int: [PreparedSpell]] {
        let validPreparedSpells = character.preparedSpells.filter { $0.baseSpell != nil }
        return Dictionary(grouping: validPreparedSpells, by: { $0.baseSpell!.niveau })
            .mapValues { $0.sorted { ($0.baseSpell?.name ?? "") < ($1.baseSpell?.name ?? "") } }
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
                        Label("Préparer", systemImage: "book")
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
                    PreparedSpellsList(spellsByLevel: spellsByLevel)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingSpellPicker) {
            SpellPickerView(character: character, availableSpells: availableSpells)
        }
    }
}

#Preview("Magicien avec armes") {
    let character = MockData.wizardWithEquippedWeapon()
    return SpellsPage(character: character)
}
