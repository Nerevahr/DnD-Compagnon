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
    @State private var pendingMagicInitiateFeat: Feat?
    
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
                            prerequisitesMet: character.meetsPrerequisites(for: feat),
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
            .sheet(item: $pendingMagicInitiateFeat) { feat in
                MagicInitiateGrantView(character: character, feat: feat)
            }
        }
    }

    private func toggleFeat(_ feat: Feat) {
        if character.feats.contains(where: { $0.id == feat.id }) {
            character.removeFeat(feat)
        } else {
            character.addFeat(feat)
            if feat.name == "Initié à la magie" {
                pendingMagicInitiateFeat = feat
            }
        }
    }
}

// MARK: - Row Component

private struct FeatManageRow: View {
    let feat: Feat
    let isSelected: Bool
    let isBackground: Bool
    let prerequisitesMet: Bool
    let onToggle: () -> Void

    /// Un don non sélectionné dont les prérequis ne sont pas remplis ne peut pas être choisi
    private var isBlockedByPrerequisites: Bool {
        !isSelected && !prerequisitesMet
    }

    private var isLocked: Bool {
        isBackground || isBlockedByPrerequisites
    }

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

                if isBlockedByPrerequisites {
                    Label(
                        "Prérequis : \(feat.prerequisites.map(\.displayText).joined(separator: ", "))",
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    .font(.caption2)
                    .foregroundColor(.orange)
                }
            }
        }
        .opacity(isLocked ? 0.6 : 1.0)
        .disabled(isLocked)
    }
}

#Preview {
    let character = Character(name: "Test")
    let feats = [
        Feat(name: "Alerte", type: .general, featDescription: "Vous gagnez +5 à l'initiative.", prerequisites: [FeatPrerequisite(type: .niveau, value: "4")]),
        Feat(name: "Costaud", type: .origine, featDescription: "Augmentez votre score de Force de 1."),
        Feat(name: "Attaque défensive", type: .styleDeCombat, featDescription: "Vous pouvez sacrifier de l'attaque pour de la défense.")
    ]
    
    return FeatManageView(character: character, allFeats: feats, backgroundFeat: feats[1])
}
