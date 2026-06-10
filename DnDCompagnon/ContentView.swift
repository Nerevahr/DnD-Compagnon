//
//  ContentView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingSearch = false

    var body: some View {
        TabView {
            // Premier onglet : Liste des Personnages
            CharacterListView()
                .tabItem {
                    Label("Personnages", systemImage: "person.fill")
                }
            
            // Deuxième onglet : Ressources (Sorts + Objets)
            ResourcesView()
                .tabItem {
                    Label("Ressources", systemImage:"book.fill")
                }
        }
        .overlay(alignment: .bottomTrailing) {
            // Bouton de recherche flottant
            Button {
                isShowingSearch = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(UIColor.systemGray))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding()
        }
        .sheet(isPresented: $isShowingSearch) {
            SearchView()
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
        container = try! ModelContainer(for: Character.self, Spell.self, Item.self,  DnDClass.self, configurations: config)
        SpellSeeder.seedIfNeeded(context: container.mainContext)
    }
    
    var body: some View {
        ContentView()
            .modelContainer(container)
    }
}
