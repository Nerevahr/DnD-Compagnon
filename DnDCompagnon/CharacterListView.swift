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

    @State private var isShowingAddAlert = false
    @State private var newItemText = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(characters) { character in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(character.text)
                                .font(.title)
                            Text("Créé le : \(character.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(character.text)
                                .font(.headline)
                            Text(character.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
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
                    Button(action: { isShowingAddAlert = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .alert("Nouvel Item", isPresented: $isShowingAddAlert) {
                TextField("Entrez votre texte ici", text: $newItemText)
                
                Button("Annuler", role: .cancel) {
                    newItemText = ""
                }
                
                Button("Ajouter") {
                    addItem(text: newItemText)
                    newItemText = ""
                }
                .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
            } message: {
                Text("Veuillez saisir le texte à enregistrer.")
            }
        } detail: {
            Text("Sélectionnez un personnage")
        }
    }

    private func addItem(text: String) {
        withAnimation {
            let newItem = Character(timestamp: Date(), text: text)
            modelContext.insert(newItem)
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
