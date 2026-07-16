//
//  SpellSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

enum SpellSeeder {

    // Structure pour décoder le JSON
    private struct SpellData: Codable {
        let name: String
        let portee: String
        let ecole: String
        let componentV: Bool
        let componentS: Bool
        let componentM: Bool
        let materialDescription: String?
        let dureeIncantation: String
        let duree: String
        let niveau: Int
        let classes: [String]
        let concentration: Bool
        let descriptionSort: String
        let isOffensive: Bool?
        let requiresSavingThrow: Bool?
        let savingThrowStat: String?
        let damageAmount: String?
        let alternateDamageAmount: String?
    }
    
    /// Insère les sorts de base uniquement si la base est vide.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // On vérifie s'il existe déjà des sorts
        let descriptor = FetchDescriptor<Spell>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // Liste des fichiers JSON à charger
        let jsonFiles = ["spells_0", "spells_1", "spells_2", "spells_8", "spells_9"]
        
        // Charger les sorts depuis les JSON
        guard let spells = loadSpellsFromJSON(fileNames: jsonFiles) else {
            print("❌ Impossible de charger les sorts depuis les JSON")
            return
        }

        // Insertion des sorts
        for spellData in spells {
            let spell = Spell(
                timestamp: Date(),
                name: spellData.name,
                portee: spellData.portee,
                ecole: spellData.ecole,
                componentV: spellData.componentV,
                componentS: spellData.componentS,
                componentM: spellData.componentM,
                materialDescription: spellData.materialDescription ?? "",
                dureeIncantation: spellData.dureeIncantation,
                duree: spellData.duree,
                niveau: spellData.niveau,
                classes: spellData.classes,
                concentration: spellData.concentration,
                descriptionSort: spellData.descriptionSort,
                isOffensive: spellData.isOffensive ?? false,
                requiresSavingThrow: spellData.requiresSavingThrow ?? false,
                savingThrowStat: spellData.savingThrowStat,
                damageAmount: spellData.damageAmount,
                alternateDamageAmount: spellData.alternateDamageAmount
            )
            context.insert(spell)
        }

        try? context.save()
    }

    // MARK: - Chargement depuis JSON
    
    private static func loadSpellsFromJSON(fileNames: [String]) -> [SpellData]? {
        var allSpells: [SpellData] = []
        
        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("⚠️ Fichier \(fileName).json introuvable")
                continue
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let spells = try decoder.decode([SpellData].self, from: data)
                allSpells.append(contentsOf: spells)
                print("✅ \(spells.count) sorts chargés depuis \(fileName).json")
            } catch {
                print("❌ Erreur lors du décodage de \(fileName).json: \(error)")
            }
        }
        
        return allSpells.isEmpty ? nil : allSpells
    }
}
