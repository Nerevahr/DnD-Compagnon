//
//  CharacterListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [Character]
    @Query private var classes: [DnDClass]

    @State private var isShowingCreateSheet = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(characters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(character.name)
                                .font(.headline)
                            HStack {
                                if let dndClass = character.dndClass {
                                    Text(dndClass.name)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                if !character.race.isEmpty {
                                    Text("• \(character.race)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("Niv. \(character.level)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Personnages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowingCreateSheet = true }) {
                        Label("Ajouter un personnage", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateSheet) {
                CharacterCreationView(availableClasses: classes) { newCharacter in
                    modelContext.insert(newCharacter)
                    isShowingCreateSheet = false
                }
            }
        } detail: {
            Text("Sélectionnez un personnage")
                .foregroundColor(.gray)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(characters[index])
            }
        }
    }
}
