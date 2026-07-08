//
//  FeatListViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftData

/// État et logique métier de la liste des dons
@Observable
final class FeatListViewModel {
    
    // MARK: - UI State
    var isShowingAddSheet = false
    
    // MARK: - Formulaire d'ajout
    var newFeatName = ""
    var newFeatType: FeatType = .general
    var newFeatDescription = ""
    
    // MARK: - Actions
    
    func addFeat(context: ModelContext) {
        let newFeat = Feat(
            name: newFeatName,
            type: newFeatType,
            featDescription: newFeatDescription
        )
        context.insert(newFeat)
        resetForm()
    }
    
    func deleteFeats(_ feats: [Feat], context: ModelContext) {
        feats.forEach { context.delete($0) }
    }
    
    // MARK: - Helpers
    
    func resetForm() {
        newFeatName = ""
        newFeatType = .general
        newFeatDescription = ""
    }
    
    /// Regroupe et trie les dons par type
    func groupedAndSorted(_ feats: [Feat]) -> [FeatType: [Feat]] {
        let grouped = Dictionary(grouping: feats) { $0.type }
        return grouped
    }
    
    /// Retourne les types de dons avec des dons, triés
    func featTypesWithFeats(_ feats: [Feat]) -> [FeatType] {
        let grouped = groupedAndSorted(feats)
        return FeatType.allCases.filter { grouped[$0] != nil }.sorted { $0.rawValue < $1.rawValue }
    }
}
