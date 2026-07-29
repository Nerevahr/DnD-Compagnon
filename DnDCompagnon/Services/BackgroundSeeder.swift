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
        let toolProficiency: String
        let skillProficiencies: [String]
        let originFeatName: String?
        let equipmentOptions: [EquipmentOptionData]
        let defaultMagicClass: String?

        struct EquipmentOptionData: Codable {
            let label: String
            let itemNames: [String]
            let goldPieces: Double
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
            // Rechercher le don d'origine par son nom
            var originFeat: Feat? = nil
            if let featName = data.originFeatName {
                let featDescriptor = FetchDescriptor<Feat>(
                    predicate: #Predicate<Feat> { $0.name == featName }
                )
                originFeat = try? context.fetch(featDescriptor).first
            }

            // Résoudre les options d'équipement (objets du catalogue par nom)
            var equipmentOptions: [BackgroundEquipmentOption] = []
            for optionData in data.equipmentOptions {
                var resolvedItems: [Item] = []
                for itemName in optionData.itemNames {
                    let itemDescriptor = FetchDescriptor<Item>(
                        predicate: #Predicate<Item> { $0.name == itemName }
                    )
                    if let item = try? context.fetch(itemDescriptor).first {
                        resolvedItems.append(item)
                    } else {
                        print("⚠️ Objet introuvable pour l'option d'équipement: \(itemName)")
                    }
                }
                let option = BackgroundEquipmentOption(
                    label: optionData.label,
                    items: resolvedItems,
                    goldPieces: optionData.goldPieces
                )
                context.insert(option)
                equipmentOptions.append(option)
            }

            let background = Background(
                name: data.name,
                description: data.description,
                suggestedStats: data.suggestedStats,
                toolProficiency: data.toolProficiency,
                skillProficiencies: data.skillProficiencies,
                originFeat: originFeat,
                equipmentOptions: equipmentOptions,
                defaultMagicClass: data.defaultMagicClass
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
