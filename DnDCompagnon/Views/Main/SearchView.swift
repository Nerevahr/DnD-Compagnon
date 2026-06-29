//
//  SearchView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var characters: [Character]
    @Query private var spells: [Spell]
    @Query private var items: [Item]
    
    @State private var searchText = ""
    
    private var filteredCharacters: [Character] {
        guard !searchText.isEmpty else { return [] }
        return characters.filter { character in
            character.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredSpells: [Spell] {
        guard !searchText.isEmpty else { return [] }
        return spells.filter { spell in
            spell.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredItems: [Item] {
        guard !searchText.isEmpty else { return [] }
        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Section Personnages
                if !filteredCharacters.isEmpty {
                    Section(header: Text("Personnages (\(filteredCharacters.count))")) {
                        ForEach(filteredCharacters) { character in
                            NavigationLink {
                                CharacterDetailView(character: character)
                            } label: {
                                VStack(alignment: .leading) {
                                    Label(character.name, systemImage: "person.fill")
                                        .font(.headline)
                                    Text(character.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                
                // Section Items
                if !filteredItems.isEmpty {
                    Section(header: Text("Objets (\(filteredItems.count))")) {
                        ForEach(filteredItems) { item in
                            NavigationLink {
                                ItemDetailView(item: item)
                            } label: {
                                VStack(alignment: .leading) {
                                    Label(item.name, systemImage: "backpack.fill")
                                        .font(.headline)
                                    Text(item.type.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                
                // Section Sorts
                if !filteredSpells.isEmpty {
                    Section(header: Text("Sorts (\(filteredSpells.count))")) {
                        ForEach(filteredSpells) { spell in
                            NavigationLink {
                                SpellDetailView(spell: spell)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Label(spell.name, systemImage: "wand.and.stars")
                                            .font(.headline)
                                        Spacer()
                                        if spell.concentration {
                                            Image(systemName: "c.circle.fill")
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    HStack {
                                        Text(spell.niveauLabel)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("•")
                                            .foregroundColor(.secondary)
                                        Text(spell.ecole)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Message si aucun résultat
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Rechercher",
                        systemImage: "magnifyingglass",
                        description: Text("Entrez du texte pour rechercher des sorts ou personnages")
                    )
                } else if filteredCharacters.isEmpty && filteredSpells.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .navigationTitle("Recherche")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Rechercher sorts, personnages...")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}
