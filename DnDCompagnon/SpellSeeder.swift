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
    }
    
    /// Insère les sorts de base uniquement si la base est vide.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // On vérifie s'il existe déjà des sorts
        let descriptor = FetchDescriptor<Spell>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // Charger les sorts depuis le JSON
        guard let spells = loadSpellsFromJSON() else {
            print("❌ Impossible de charger les sorts depuis le JSON")
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
                descriptionSort: spellData.descriptionSort
            )
            context.insert(spell)
        }

        try? context.save()
    }

    // MARK: - Chargement depuis JSON
    
    private static func loadSpellsFromJSON() -> [SpellData]? {
        guard let url = Bundle.main.url(forResource: "spells", withExtension: "json") else {
            print("❌ Fichier spells.json introuvable")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let spells = try decoder.decode([SpellData].self, from: data)
            return spells
        } catch {
            print("❌ Erreur lors du décodage du JSON: \(error)")
            return nil
        }
    }
}
