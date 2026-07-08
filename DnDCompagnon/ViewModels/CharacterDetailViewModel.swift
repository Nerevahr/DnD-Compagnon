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
    
    // MARK: - Initialization
    init(character: Character) {
        self.character = character
    }
}
