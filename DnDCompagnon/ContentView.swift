//
//  ContentView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    // ÉTAPE 1 : Variables d'état pour gérer l'alerte et la saisie
    @State private var isShowingAddAlert = false
    @State private var newItemText = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        // Affichage du texte dans le détail
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.text)
                                .font(.title)
                            Text("Créé le : \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.text)
                                .font(.headline)
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
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
            .alert("Nouveau personnage", isPresented: $isShowingAddAlert) {
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
                Text("Veuillez saisir le nom du personnage.")
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem(text: String) {
        withAnimation {
            let newItem = Item(timestamp: Date(), text: text)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
