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
            
            SpellListView()
                .tabItem {
                    Label("Sorts", systemImage: "wand.and.stars")
                }
        }
    }
}

#Preview {
    PreviewHelper()
}

private struct PreviewHelper: View {
    let container: ModelContainer
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: Character.self, Spell.self, configurations: config)
        SpellSeeder.seedIfNeeded(context: container.mainContext)
    }
    
    var body: some View {
        ContentView()
            .modelContainer(container)
    }
}
