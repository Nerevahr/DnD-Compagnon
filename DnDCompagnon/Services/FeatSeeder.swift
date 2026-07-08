//
//  FeatSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftData

enum FeatSeeder {
    
    // Structure pour décoder le JSON
    private struct FeatData: Codable {
        let name: String
        let type: FeatType
        let featDescription: String
    }
    
    /// Insère les dons de base uniquement si la base est vide.
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Feat>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }
        
        // Charger les dons depuis le JSON
        guard let featsData = loadFeatsFromJSON() else {
            print("❌ Impossible de charger les dons depuis le JSON")
            return
        }
        
        // Insertion des dons
        for featData in featsData {
            let feat = Feat(
                name: featData.name,
                type: featData.type,
                featDescription: featData.featDescription
            )
            context.insert(feat)
        }
        
        try? context.save()
        print("✅ Dons chargés avec succès")
    }
    
    // MARK: - Chargement depuis JSON
    
    private static func loadFeatsFromJSON() -> [FeatData]? {
        guard let url = Bundle.main.url(forResource: "feats", withExtension: "json") else {
            print("❌ Fichier feats.json introuvable")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let feats = try decoder.decode([FeatData].self, from: data)
            return feats
        } catch {
            print("❌ Erreur lors du décodage du JSON: \(error)")
            return nil
        }
    }
}
