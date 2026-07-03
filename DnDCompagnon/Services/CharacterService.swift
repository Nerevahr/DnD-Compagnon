//
//  CharacterService.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 14/06/2026.
//


import Foundation
import SwiftData

enum CharacterService {
        
    @MainActor
    static func createCharacter(
        name: String,
        level: Int,
        dndClass: DnDClass?,
        race: Race?,           // ← était String
        background: Background?, // ← était origin: Background?
        strength: Int,
        dexterity: Int,
        constitution: Int,
        intelligence: Int,
        wisdom: Int,
        charisma: Int,
        proficientSkills: [String],
        context: ModelContext
    ) throws -> Character {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw CharacterCreationError.invalidName
        }

        let character = Character(
            timestamp: Date(),
            name: name,
            level: level,
            dndClass: dndClass,
            race: race,
            origin: background,
            strength: strength,
            dexterity: dexterity,
            constitution: constitution,
            intelligence: intelligence,
            wisdom: wisdom,
            charisma: charisma,
            proficientSkills: proficientSkills
        )

        context.insert(character)
        try context.save()

        return character
    }
    
    @MainActor
    static func restoreAllSpellSlots(character: Character, context: ModelContext) throws {
        character.restoreAllSpellSlots()
        try context.save()
    }
    
    // Autres méthodes utiles :
    // - updateCharacter(...)
    // - deleteCharacter(...)
    // - duplicateCharacter(...)
    // - generateRandomStats() -> [String: Int]
}

enum CharacterCreationError: Error {
    case invalidName
    case invalidStats
    case missingClass
}
