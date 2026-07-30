//
//  SpellSheetSelectorView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import SwiftUI
import SwiftData

/// Vue permettant de sélectionner une fiche de sorts pour remplacer les sorts préparés du personnage
struct SpellSheetSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \SpellSheet.timestamp, order: .reverse) private var spellSheets: [SpellSheet]

    @Bindable var character: Character

    @State private var spellSheetPendingConfirmation: SpellSheet?

    var body: some View {
        NavigationStack {
            List {
                ForEach(spellSheets) { spellSheet in
                    Button {
                        spellSheetPendingConfirmation = spellSheet
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(spellSheet.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(spellCountText(for: spellSheet))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Choisir une fiche de sorts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
            .overlay {
                if spellSheets.isEmpty {
                    ContentUnavailableView(
                        "Aucune fiche de sorts",
                        systemImage: "list.bullet.rectangle.portrait",
                        description: Text("Créez une fiche de sorts pour pouvoir l'appliquer à ce personnage.")
                    )
                }
            }
            .confirmationDialog(
                confirmationTitle,
                isPresented: Binding(
                    get: { spellSheetPendingConfirmation != nil },
                    set: { if !$0 { spellSheetPendingConfirmation = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Remplacer", role: .destructive) {
                    if let spellSheet = spellSheetPendingConfirmation {
                        character.applySpellSheet(spellSheet)
                    }
                    dismiss()
                }
                Button("Annuler", role: .cancel) {
                    spellSheetPendingConfirmation = nil
                }
            } message: {
                Text("Les sorts préparés actuels (hors sorts mineurs et sorts toujours préparés) seront remplacés par ceux de cette fiche.")
            }
        }
    }

    private var confirmationTitle: String {
        guard let title = spellSheetPendingConfirmation?.title else { return "" }
        return "Appliquer « \(title) » ?"
    }

    private func spellCountText(for spellSheet: SpellSheet) -> String {
        let count = spellSheet.preparedSpells.count
        return count > 1 ? "\(count) sorts" : "\(count) sort"
    }
}

#Preview {
    let character = MockData.wizardWithEquippedWeapon()
    return SpellSheetSelectorView(character: character)
}
