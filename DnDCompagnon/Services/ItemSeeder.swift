//
//  ItemSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//

import Foundation
import SwiftData

enum ItemSeeder {

    // Structure pour décoder le JSON
    private struct ItemData: Codable {
        let name: String
        let itemDescription: String
        let type: String // "Objet", "Armure", "Arme", "Bouclier", "Outils"
        
        // Propriétés spécifiques aux armures
        let armorCategory: String?
        let baseArmorClass: Int?
        
        // Propriétés spécifiques aux armes
        let weaponType: String?
        let damageDice: String?
        let damageType: String?
    }
    
    /// Insère les objets du catalogue manquants (par nom), sans dupliquer ceux déjà présents.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // Liste des fichiers JSON à charger
        let jsonFiles = ["items"] // Ajoutez ici d'autres fichiers si nécessaire

        // Charger les objets depuis les JSON
        guard let items = loadItemsFromJSON(fileNames: jsonFiles) else {
            print("❌ Impossible de charger les objets depuis les JSON")
            return
        }

        // Ne pas réinsérer les objets déjà présents dans le catalogue
        let existingNames = Set((try? context.fetch(FetchDescriptor<Item>()))?.map(\.name) ?? [])

        // Insertion des objets manquants
        var insertedCount = 0
        for itemData in items where !existingNames.contains(itemData.name) {
            let item = Item(
                timestamp: Date(),
                name: itemData.name,
                itemDescription: itemData.itemDescription,
                type: ItemType(rawValue: itemData.type) ?? .objet,
                imageData: nil,
                armorCategory: itemData.armorCategory.flatMap { ArmorCategory(rawValue: $0) },
                baseArmorClass: itemData.baseArmorClass,
                weaponType: itemData.weaponType.flatMap { WeaponType(rawValue: $0) },
                damageDice: itemData.damageDice,
                damageType: itemData.damageType.flatMap { DamageType(rawValue: $0) }
            )
            context.insert(item)
            insertedCount += 1
        }

        guard insertedCount > 0 else { return }
        try? context.save()
    }

    // MARK: - Chargement depuis JSON
    
    private static func loadItemsFromJSON(fileNames: [String]) -> [ItemData]? {
        var allItems: [ItemData] = []
        
        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("⚠️ Fichier \(fileName).json introuvable")
                continue
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let items = try decoder.decode([ItemData].self, from: data)
                allItems.append(contentsOf: items)
                print("✅ \(items.count) objets chargés depuis \(fileName).json")
            } catch {
                print("❌ Erreur lors du décodage de \(fileName).json: \(error)")
            }
        }
        
        return allItems.isEmpty ? nil : allItems
    }
}
