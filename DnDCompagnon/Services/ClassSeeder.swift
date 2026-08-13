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
        let spellSlots: [String: [String: Int]]? // ⬅️ AJOUT
        let classResources: [ClassResourceData]?
        let equipmentOptions: [EquipmentOptionData]?

        struct AbilityData: Codable {
            let level: Int
            let name: String
            let description: String?
        }

        struct ClassResourceData: Codable {
            let name: String
            let amountsByLevel: [String: Int]
        }

        struct EquipmentOptionData: Codable {
            let itemNames: [String]
            let goldPieces: Double
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
            
            // Convertir les spell slots de [String: [String: Int]] vers [Int: [Int: Int]]
            var spellSlots: [Int: [Int: Int]] = [:]
            if let jsonSpellSlots = classData.spellSlots {
                for (charLevelStr, spellLevels) in jsonSpellSlots {
                    if let charLevel = Int(charLevelStr) {
                        var levelSlots: [Int: Int] = [:]
                        for (spellLevelStr, count) in spellLevels {
                            if let spellLevel = Int(spellLevelStr) {
                                levelSlots[spellLevel] = count
                            }
                        }
                        spellSlots[charLevel] = levelSlots
                    }
                }
            }
            
            // Convertir les ressources de classe : clés String -> Int pour amountsByLevel
            let classResources: [ClassResource] = (classData.classResources ?? []).map { resourceData in
                var amountsByLevel: [Int: Int] = [:]
                for (levelStr, amount) in resourceData.amountsByLevel {
                    if let level = Int(levelStr) {
                        amountsByLevel[level] = amount
                    }
                }
                return ClassResource(name: resourceData.name, amountsByLevel: amountsByLevel)
            }

            // Résoudre les options d'équipement (objets du catalogue par nom)
            var equipmentOptions: [ClassEquipmentOption] = []
            for optionData in classData.equipmentOptions ?? [] {
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
                let option = ClassEquipmentOption(
                    items: resolvedItems,
                    goldPieces: optionData.goldPieces
                )
                context.insert(option)
                equipmentOptions.append(option)
            }

            let dndClass = DnDClass(
                timestamp: Date(),
                name: classData.name,
                descriptionClass: classData.descriptionClass,
                abilities: abilities,
                masteredStats: classData.masteredStats,
                spellcastingAbility: classData.spellcastingAbility,
                masteredSkills: classData.masteredSkills,
                spellSlots: spellSlots, // ⬅️ AJOUT
                classResources: classResources,
                equipmentOptions: equipmentOptions
            )
            context.insert(dndClass)
        }

        try? context.save()
        print("✅ Classes chargées avec succès (dont spell slots et ressources de classe)")
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
