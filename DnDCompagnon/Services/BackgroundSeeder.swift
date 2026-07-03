//
//  BackgroundSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Services/BackgroundSeeder.swift
import Foundation
import SwiftData

enum BackgroundSeeder {

    private struct BackgroundData: Codable {
        let name: String
        let description: String
        let suggestedStats: [String]
        let feature: FeatureData
        let toolProficiency: String

        struct FeatureData: Codable {
            let name: String
            let description: String
        }
    }

    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Background>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        guard let backgrounds = loadFromJSON(fileNames: ["backgrounds"]) else {
            print("❌ Impossible de charger les origines depuis les JSON")
            return
        }

        for data in backgrounds {
            let feature = BackgroundAbility(name: data.feature.name, abilityDescription: data.feature.description)
            let background = Background(
                name: data.name,
                description: data.description,
                suggestedStats: data.suggestedStats,
                feature: feature,
                toolProficiency: data.toolProficiency
            )
            context.insert(background)
        }

        try? context.save()
        print("✅ \(backgrounds.count) origines chargées avec succès")
    }

    private static func loadFromJSON(fileNames: [String]) -> [BackgroundData]? {
        var all: [BackgroundData] = []

        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("⚠️ Fichier \(fileName).json introuvable")
                continue
            }

            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([BackgroundData].self, from: data)
                all.append(contentsOf: decoded)
                print("✅ \(decoded.count) origines chargées depuis \(fileName).json")
            } catch {
                print("❌ Erreur lors du décodage de \(fileName).json: \(error)")
            }
        }

        return all.isEmpty ? nil : all
    }
}
