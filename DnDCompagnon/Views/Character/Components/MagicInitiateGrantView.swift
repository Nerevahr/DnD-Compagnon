//
//  MagicInitiateGrantView.swift
//  DnDCompagnon
//

import SwiftUI
import SwiftData

/// Sheet permettant de choisir les sorts octroyés par le don "Initié à la magie"
/// lorsqu'il est ajouté après la création du personnage.
/// Si le joueur annule avant d'avoir terminé sa sélection, le don est retiré du personnage
/// pour ne pas laisser un don "orphelin" sans ses sorts.
struct MagicInitiateGrantView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var character: Character
    let feat: Feat

    @Query(sort: \Spell.name) private var allSpells: [Spell]

    @State private var selectedMagicClass: String = Background.magicInitiateClasses.first ?? "Druide"
    @State private var selectedCantripIDs: Set<PersistentIdentifier> = []
    @State private var selectedLevel1SpellID: PersistentIdentifier?

    private var availableCantrips: [Spell] {
        allSpells.filter { $0.niveau == 0 && $0.classes.contains(selectedMagicClass) }
            .sorted { $0.name < $1.name }
    }

    private var availableLevel1Spells: [Spell] {
        allSpells.filter { $0.niveau == 1 && $0.classes.contains(selectedMagicClass) }
            .sorted { $0.name < $1.name }
    }

    private var isSelectionValid: Bool {
        selectedCantripIDs.count == 2 && selectedLevel1SpellID != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Classe de magie", selection: $selectedMagicClass) {
                        ForEach(Background.magicInitiateClasses, id: \.self) { magicClass in
                            Text(magicClass).tag(magicClass)
                        }
                    }
                    .onChange(of: selectedMagicClass) { _, _ in
                        selectedCantripIDs = []
                        selectedLevel1SpellID = nil
                    }
                } header: {
                    Text("Initié à la magie")
                } footer: {
                    Text("Choisissez 2 sorts mineurs et 1 sort de niveau 1 dans la liste de sorts d'une classe.")
                }

                Section("Sorts mineurs (2)") {
                    ForEach(availableCantrips) { spell in
                        Button {
                            if selectedCantripIDs.contains(spell.id) {
                                selectedCantripIDs.remove(spell.id)
                            } else if selectedCantripIDs.count < 2 {
                                selectedCantripIDs.insert(spell.id)
                            }
                        } label: {
                            HStack {
                                Text(spell.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedCantripIDs.contains(spell.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(selectedCantripIDs.count == 2 && !selectedCantripIDs.contains(spell.id))
                    }
                }

                Section("Sort de niveau 1") {
                    Picker("Sort de niveau 1", selection: $selectedLevel1SpellID) {
                        Text("Aucun").tag(nil as PersistentIdentifier?)
                        ForEach(availableLevel1Spells) { spell in
                            Text(spell.name).tag(spell.id as PersistentIdentifier?)
                        }
                    }
                }
            }
            .navigationTitle("Sorts d'Initié à la magie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        character.removeFeat(feat)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Valider") {
                        confirmGrant()
                    }
                    .disabled(!isSelectionValid)
                }
            }
        }
        .interactiveDismissDisabled()
    }

    private func confirmGrant() {
        for cantripID in selectedCantripIDs {
            if let spell = allSpells.first(where: { $0.id == cantripID }) {
                character.prepareSpell(spell, source: .don, sourceFeat: feat)
            }
        }

        if let level1SpellID = selectedLevel1SpellID,
           let spell = allSpells.first(where: { $0.id == level1SpellID }) {
            character.prepareSpell(spell, isAlwaysPrepared: true, source: .don, sourceFeat: feat)
        }

        dismiss()
    }
}

#Preview {
    let character = Character(name: "Test")
    let feat = Feat(name: "Initié à la magie", type: .origine, featDescription: "")
    return MagicInitiateGrantView(character: character, feat: feat)
}
