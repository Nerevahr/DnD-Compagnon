//
//  SpellPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  SpellPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

/// Vue pour sélectionner des sorts à ajouter
struct SpellPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var character: Character
    let availableSpells: [Spell]
    
    @State private var searchText = ""
    @State private var selectedLevel: Int? = nil
    @State private var showAllClasses = false
    
    @Query private var allSpells: [Spell]
    
    var spellsToDisplay: [Spell] {
        if showAllClasses {
            // Tous les sorts moins ceux déjà préparés
            return allSpells.filter { spell in
                !character.preparedSpells.contains(where: { $0.id == spell.id })
            }
        } else {
            // Seulement les sorts de la classe du personnage
            return availableSpells
        }
    }
    
    var filteredSpells: [Spell] {
        var spells = spellsToDisplay
        
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
                // Toggle pour afficher toutes les classes
                HStack {
                    Toggle("Afficher tous les sorts", isOn: $showAllClasses)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // Contenu principal
                if !showAllClasses && character.dndClass == nil {
                    ContentUnavailableView(
                        "Aucune classe sélectionnée",
                        systemImage: "shield.slash",
                        description: Text("Sélectionnez une classe pour votre personnage ou activez 'Afficher tous les sorts'.")
                    )
                } else if filteredSpells.isEmpty {
                    ContentUnavailableView(
                        "Aucun sort trouvé",
                        systemImage: "sparkles",
                        description: Text("Modifiez vos critères de recherche ou tous les sorts sont déjà préparés.")
                    )
                } else {
                    SpellSelectionList(
                        spellsByLevel: spellsByLevel,
                        showAllClasses: showAllClasses,
                        onAddSpell: addSpell
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
    
    private func addSpell(_ spell: Spell) {
        withAnimation {
            character.preparedSpells.append(spell)
        }
    }
}

// MARK: - Spell Selection List

/// Liste des sorts disponibles pour sélection
struct SpellSelectionList: View {
    let spellsByLevel: [Int: [Spell]]
    let showAllClasses: Bool
    let onAddSpell: (Spell) -> Void
    
    var body: some View {
        List {
            ForEach(spellsByLevel.keys.sorted(), id: \.self) { level in
                Section(level == 0 ? "Tours de magie" : "Niveau \(level)") {
                    ForEach(spellsByLevel[level] ?? [], id: \.id) { spell in
                        SpellSelectionRow(
                            spell: spell,
                            showClasses: showAllClasses,
                            onAdd: { onAddSpell(spell) }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Spell Selection Row

/// Ligne de sélection d'un sort
struct SpellSelectionRow: View {
    let spell: Spell
    let showClasses: Bool
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(spell.name)
                        .font(.body)
                    
                    HStack(spacing: 8) {
                        Text(spell.ecole)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if spell.concentration {
                            Label("C", systemImage: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        
                        // Afficher les classes si mode "tous les sorts"
                        if showClasses {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(spell.classes.prefix(2).joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}