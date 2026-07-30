//
//  SpellSheetPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import SwiftUI
import SwiftData

/// Vue pour sélectionner des sorts à ajouter à une fiche de sorts
struct SpellSheetPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var spellSheet: SpellSheet

    @State private var searchText = ""
    @State private var selectedLevel: Int? = nil

    @Query private var allSpells: [Spell]

    // Set d'identifiants des sorts déjà présents dans la fiche
    private var addedSpellIds: Set<PersistentIdentifier> {
        Set(spellSheet.preparedSpells.compactMap { $0.baseSpell?.persistentModelID })
    }

    var filteredSpells: [Spell] {
        var spells = allSpells

        if !searchText.isEmpty {
            spells = spells.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        if let level = selectedLevel {
            spells = spells.filter { $0.niveau == level }
        }

        return spells.sorted { $0.name < $1.name }
    }

    var spellsByLevel: [Int: [Spell]] {
        Dictionary(grouping: filteredSpells, by: { $0.niveau })
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if filteredSpells.isEmpty {
                    ContentUnavailableView(
                        "Aucun sort trouvé",
                        systemImage: "sparkles",
                        description: Text("Modifiez vos critères de recherche.")
                    )
                } else {
                    SpellSelectionList(
                        spellsByLevel: spellsByLevel,
                        showAllClasses: true,
                        selectedSpellIds: addedSpellIds,
                        onToggleSpell: toggleSpell
                    )
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un sort")
            .navigationTitle("Ajouter des sorts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggleSpell(_ spell: Spell) {
        withAnimation {
            if let index = spellSheet.preparedSpells.firstIndex(where: {
                $0.baseSpell?.persistentModelID == spell.persistentModelID
            }) {
                spellSheet.preparedSpells.remove(at: index)
            } else {
                spellSheet.addSpell(spell)
            }
        }
    }
}
