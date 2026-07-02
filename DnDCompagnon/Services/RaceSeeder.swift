//
//  RaceSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//

import Foundation
import SwiftData

enum RaceSeeder {

    // Structure pour décoder le JSON
    private struct RaceData: Codable {
        let name: String
        let abilities: [RaceAbilityData]
        let abilityBonuses: [String: Int]
        let speed: Int?
        let defaultSize: String?
        
        struct RaceAbilityData: Codable {
            let name: String
            let description: String
        }
    }
    
    /// Insère les races de base uniquement si la base est vide.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // On vérifie s'il existe déjà des races
        let descriptor = FetchDescriptor<Race>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // Liste des fichiers JSON à charger
        let jsonFiles = ["races"] // Ajoutez ici d'autres fichiers si nécessaire
        
        // Charger les races depuis les JSON
        guard let races = loadRacesFromJSON(fileNames: jsonFiles) else {
            print("❌ Impossible de charger les races depuis les JSON")
            return
        }

        // Insertion des races
        for raceData in races {
            let abilities = raceData.abilities.map { abilityData in
                RaceAbility(
                    name: abilityData.name,
                    description: abilityData.description
                )
            }
            
            let race = Race(
                name: raceData.name,
                abilities: abilities,
                abilityBonuses: raceData.abilityBonuses,
                speed: raceData.speed,
                defaultSize: raceData.defaultSize ?? "Moyen"
            )
            context.insert(race)
        }

        try? context.save()
        print("✅ \(races.count) races chargées avec succès")
    }

    // MARK: - Chargement depuis JSON
    
    private static func loadRacesFromJSON(fileNames: [String]) -> [RaceData]? {
        var allRaces: [RaceData] = []
        
        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("⚠️ Fichier \(fileName).json introuvable")
                continue
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let races = try decoder.decode([RaceData].self, from: data)
                allRaces.append(contentsOf: races)
                print("✅ \(races.count) races chargées depuis \(fileName).json")
            } catch {
                print("❌ Erreur lors du décodage de \(fileName).json: \(error)")
            }
        }
        
        return allRaces.isEmpty ? nil : allRaces
    }
}
