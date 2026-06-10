//
//  DnDCompagnonApp.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

@main
struct DnDCompagnonApp: App {
    let container: ModelContainer

    init() {
        do {
            let config = ModelConfiguration(
                schema: Schema([Character.self, Spell.self]),
                isStoredInMemoryOnly: false
            )
            container = try ModelContainer(for: Character.self, Spell.self, configurations: config)
            
            // ⚠️ AJOUT : Charger les sorts de base si nécessaire
            SpellSeeder.seedIfNeeded(context: container.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
