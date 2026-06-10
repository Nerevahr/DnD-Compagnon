//
//  ContentView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            // Premier onglet : Liste des Personnages
            CharacterListView()
                .tabItem {
                    Label("Personnages", systemImage: "person.fill")
                }
            
            // Deuxième onglet : Liste des Sorts (Grille/Liste d'attente)
            SpellListView()
                .tabItem {
                    Label("Sorts", systemImage: "wand.and.stars")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Character.self, Spell.self], inMemory: true)
}
