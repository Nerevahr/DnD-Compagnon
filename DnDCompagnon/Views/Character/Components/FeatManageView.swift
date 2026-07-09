//
//  FeatManageView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 09/07/2026.
//

import SwiftUI

/// Vue pour gérer les dons du personnage avec une interface de sélection/déselection
struct FeatManageView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var character: Character
    let allFeats: [Feat]
    let backgroundFeat: Feat?
    
    @State private var searchText = ""
    
    private var filteredFeats: [Feat] {
        allFeats.filter { feat in
            searchText.isEmpty || feat.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if filteredFeats.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "Aucun don" : "Aucun résultat",
                        systemImage: "sparkles",
                        description: Text(searchText.isEmpty ? "Aucun don disponible" : "Essayez une autre recherche")
                    )
                } else {
                    ForEach(filteredFeats) { feat in
                        FeatManageRow(
                            feat: feat,
                            isSelected: character.feats.contains { $0.id == feat.id },
                            isBackground: feat.id == backgroundFeat?.id,
                            onToggle: { toggleFeat(feat) }
                        )
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un don")
            .navigationTitle("Gérer les dons")
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
    
    private func toggleFeat(_ feat: Feat) {
        if character.feats.contains(where: { $0.id == feat.id }) {
            character.removeFeat(feat)
        } else {
            character.addFeat(feat)
        }
    }
}

// MARK: - Row Component

private struct FeatManageRow: View {
    let feat: Feat
    let isSelected: Bool
    let isBackground: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            if isBackground {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .opacity(0.5)
            } else {
                Button(action: onToggle) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                .buttonStyle(.plain)
            }
            
            // Contenu du don
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(feat.type.color)
                        .frame(width: 8, height: 8)
                    
                    Text(feat.name)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    if isBackground {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(feat.featDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .opacity(isBackground ? 0.6 : 1.0)
        .disabled(isBackground)
    }
}

#Preview {
    let character = Character(name: "Test")
    let feats = [
        Feat(name: "Alerte", type: .general, featDescription: "Vous gagnez +5 à l'initiative."),
        Feat(name: "Costaud", type: .origine, featDescription: "Augmentez votre score de Force de 1."),
        Feat(name: "Attaque défensive", type: .styleDeCombat, featDescription: "Vous pouvez sacrifier de l'attaque pour de la défense.")
    ]
    
    return FeatManageView(character: character, allFeats: feats, backgroundFeat: feats[1])
}
