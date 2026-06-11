//
//  ClassSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  ClassSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import Foundation
import SwiftData

enum ClassSeeder {

    // Structure pour décoder le JSON
    private struct ClassData: Codable {
        let name: String
        let descriptionClass: String
        let abilities: [AbilityData]
        let masteredStats: [String]
        let spellcastingAbility: String
        let masteredSkills: [String]
        
        struct AbilityData: Codable {
            let level: Int
            let name: String
            let description: String?
        }
    }
    
    /// Insère les classes de base uniquement si la base est vide.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // On vérifie s'il existe déjà des classes
        let descriptor = FetchDescriptor<DnDClass>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // Charger les classes depuis le JSON
        guard let classes = loadClassesFromJSON() else {
            print("❌ Impossible de charger les classes depuis le JSON")
            return
        }

        // Insertion des classes
        for classData in classes {
            let abilities = classData.abilities.map { abilityData in
                ClassAbility(
                    level: abilityData.level,
                    name: abilityData.name,
                    description: abilityData.description
                )
            }
            
            let dndClass = DnDClass(
                timestamp: Date(),
                name: classData.name,
                descriptionClass: classData.descriptionClass,
                abilities: abilities,
                masteredStats: classData.masteredStats,
                spellcastingAbility: classData.spellcastingAbility,
                masteredSkills: classData.masteredSkills
            )
            context.insert(dndClass)
        }

        try? context.save()
    }

    // MARK: - Chargement depuis JSON
    
    private static func loadClassesFromJSON() -> [ClassData]? {
        guard let url = Bundle.main.url(forResource: "classes", withExtension: "json") else {
            print("❌ Fichier classes.json introuvable")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let classes = try decoder.decode([ClassData].self, from: data)
            return classes
        } catch {
            print("❌ Erreur lors du décodage du JSON: \(error)")
            return nil
        }
    }
}