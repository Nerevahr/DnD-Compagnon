//
//  SpellSheetDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import SwiftUI
import SwiftData

/// Affiche le contenu d'une fiche de sorts : titre éditable + sorts qu'elle contient
struct SpellSheetDetailView: View {
    @Bindable var spellSheet: SpellSheet
    @State private var isShowingSpellPicker = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Titre de la fiche", text: $spellSheet.title)
                    .font(.title2)
                    .fontWeight(.bold)

                HStack {
                    Text("Sorts")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(action: { isShowingSpellPicker = true }) {
                        Label("Ajouter", systemImage: "book")
                            .font(.headline)
                    }
                }

                if spellSheet.preparedSpells.isEmpty {
                    EmptySpellsView()
                } else {
                    PreparedSpellsList(spellsByLevel: spellSheet.preparedSpellsByLevel)
                }
            }
            .padding()
        }
        .navigationTitle(spellSheet.title.isEmpty ? "Fiche de sorts" : spellSheet.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingSpellPicker) {
            SpellSheetPickerView(spellSheet: spellSheet)
        }
    }
}
