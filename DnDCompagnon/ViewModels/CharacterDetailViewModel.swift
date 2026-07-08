//
//  CharacterDetailViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftData

/// État et logique métier de la vue détail du personnage
@Observable
@MainActor
final class CharacterDetailViewModel {
    let character: Character
    
    // MARK: - UI State
    var isShowingEditSheet = false
    var currentPage = 0
    var showLevelUpSheet = false
    var showLevelDownConfirmation = false
    
    // MARK: - Initialization
    init(character: Character) {
        self.character = character
    }
    
    // MARK: - Level Management
    func requestLevelUp() {
        showLevelUpSheet = true
    }
    
    func requestLevelDown() {
        showLevelDownConfirmation = true
    }
    
    func confirmLevelDown() {
        character.levelDown()
        showLevelDownConfirmation = false
    }
}
