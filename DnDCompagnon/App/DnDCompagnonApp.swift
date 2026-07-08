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
                schema: Schema([Character.self, Spell.self, Item.self, DnDClass.self, Race.self, Background.self, Feat.self]),
                isStoredInMemoryOnly: false
            )
            container = try ModelContainer(for: Character.self, Spell.self, Item.self, DnDClass.self, Race.self, Background.self, Feat.self, configurations: config)
            
            SpellSeeder.seedIfNeeded(context: container.mainContext)
            ClassSeeder.seedIfNeeded(context: container.mainContext)
            ItemSeeder.seedIfNeeded(context: container.mainContext)
            RaceSeeder.seedIfNeeded(context: container.mainContext)
            BackgroundSeeder.seedIfNeeded(context: container.mainContext)
            FeatSeeder.seedIfNeeded(context: container.mainContext)
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

