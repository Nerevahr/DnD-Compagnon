//
//  FeatPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI

/// Vue pour ajouter des dons au personnage depuis le catalogue
struct FeatPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var character: Character
    let allFeats: [Feat]
    
    @State private var searchText = ""
    
    // Dons non encore attribués, filtrés par recherche
    private var availableFeats: [Feat] {
        allFeats.filter { feat in
            !character.feats.contains { $0.id == feat.id } &&
            (searchText.isEmpty || feat.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if availableFeats.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "Aucun don disponible" : "Aucun résultat",
                        systemImage: "sparkles",
                        description: Text(searchText.isEmpty ? "Tous les dons sont déjà attribués" : "Essayez une autre recherche")
                    )
                } else {
                    ForEach(availableFeats) { feat in
                        Button {
                            addFeatToCharacter(feat)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(feat.type.color)
                                            .frame(width: 8, height: 8)
                                        Text(feat.name)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Text(feat.featDescription)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un don")
            .navigationTitle("Ajouter un don")
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
    
    private func addFeatToCharacter(_ feat: Feat) {
        character.addFeat(feat)
        dismiss()
    }
}

#Preview {
    let character = Character(name: "Test")
    let feats = [
        Feat(name: "Alerte", type: .general, featDescription: "Vous gagnez +5 à l'initiative."),
        Feat(name: "Costaud", type: .origine, featDescription: "Augmentez votre score de Force de 1.")
    ]
    
    return FeatPickerView(character: character, allFeats: feats)
}
