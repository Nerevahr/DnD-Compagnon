//
//  CharacterEditViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftData

/// État et logique métier de la vue d'édition du personnage
@Observable
@MainActor
final class CharacterEditViewModel {
    let character: Character
    
    // MARK: - UI State
    var proficientSkills: Set<String> = []
    var showLevelUpSheet = false
    var showLevelDownConfirmation = false
    
    // MARK: - Initialization
    init(character: Character) {
        self.character = character
        loadProficientSkills()
    }
    
    // MARK: - Data Loading
    func loadProficientSkills() {
        proficientSkills = Set(character.proficientSkills)
    }
    
    // MARK: - Skills Management
    func toggleSkill(_ skillName: String) {
        if proficientSkills.contains(skillName) {
            proficientSkills.remove(skillName)
        } else {
            proficientSkills.insert(skillName)
        }
    }
    
    // MARK: - Level Management
    func requestLevelUp() {
        showLevelUpSheet = true
    }
    
    func requestLevelDown() {
        showLevelDownConfirmation = true
    }
    
    func confirmLevelDown(modelContext: ModelContext) {
        character.levelDown()
        try? modelContext.save()
        showLevelDownConfirmation = false
    }
    
    // MARK: - Skill Sorting
    func sortedSkills() -> [DnDSkill] {
        let statOrder = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
        return Character.allSkills.sorted { skill1, skill2 in
            let index1 = statOrder.firstIndex(of: skill1.baseStat) ?? 999
            let index2 = statOrder.firstIndex(of: skill2.baseStat) ?? 999
            if index1 == index2 { return skill1.name < skill2.name }
            return index1 < index2
        }
    }
    
    // MARK: - Persistence
    func save(modelContext: ModelContext) {
        character.proficientSkills = Array(proficientSkills)
        try? modelContext.save()
    }
}
