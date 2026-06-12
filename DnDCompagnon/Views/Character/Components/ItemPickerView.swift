//
//  ItemPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

/// Vue pour ajouter des items à l'inventaire
struct ItemPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var character: Character
    let allItems: [Item]
    
    @State private var searchText = ""
    
    // Items non encore dans l'inventaire
    private var availableItems: [Item] {
        allItems.filter { item in
            !character.inventory.contains(item) &&
            (searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if availableItems.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "Aucun objet disponible" : "Aucun résultat",
                        systemImage: "magnifyingglass",
                        description: Text(searchText.isEmpty ? "Tous les objets sont déjà dans l'inventaire" : "Essayez une autre recherche")
                    )
                } else {
                    ForEach(availableItems) { item in
                        Button {
                            addToInventory(item)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Text(item.type.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un objet")
            .navigationTitle("Ajouter à l'inventaire")
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
    
    private func addToInventory(_ item: Item) {
        character.inventory.append(item)
        dismiss()
    }
}