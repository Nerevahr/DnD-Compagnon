//
//  CharacterJSON.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 24/06/2026.
//


import Foundation
import SwiftData
import UIKit

// MARK: - Structures JSON pour l'export/import

struct CharacterJSON: Codable {
    var name: String
    var level: Int
    var race: String // Changé de race à raceName
    var origin: String
    var size: String
    
    // Stats de base
    var strength: Int
    var dexterity: Int
    var constitution: Int
    var intelligence: Int
    var wisdom: Int
    var charisma: Int
    
    // Points de vie
    var currentHitPoints: Int
    var maximumHitPoints: Int
    
    // Classe (juste le nom, car DnDClass est complexe)
    var className: String?
    
    // Compétences maîtrisées
    var proficientSkills: [String]
    
    // Emplacements de sorts utilisés
    var usedSpellSlots: [String: Int] // Utilise String comme clé pour JSON
    
    // Sorts préparés (juste les noms)
    var preparedSpellNames: [String]
    
    // Inventaire (simplifié - juste les noms)
    var inventoryItemNames: [String]
    
    // Équipement équipé (juste les noms)
    var equippedArmorName: String?
    var equippedWeaponName: String?
    var equippedShieldName: String?
    
    // Or
    var gold: Double
    
    // Image de profil (encodée en base64)
    var profileImageBase64: String?
    
    // Métadonnées
    var exportDate: Date
    var appVersion: String
}

// MARK: - Service d'Import/Export

enum CharacterImportExportService {
    
    // MARK: - Export
    
    /// Exporte un personnage au format JSON
    /// - Parameter character: Le personnage à exporter
    /// - Returns: Les données JSON
    @MainActor
    static func exportCharacter(_ character: Character) throws -> Data {
        // Convertir usedSpellSlots avec clés String
        let usedSpellSlotsStringKeys = character.usedSpellSlots.reduce(into: [String: Int]()) { result, pair in
            result[String(pair.key)] = pair.value
        }
        
        // Encoder l'image de profil en base64 si présente
        let profileImageBase64: String? = character.profileImageData.map {
            $0.base64EncodedString()
        }
        
        let characterJSON = CharacterJSON(
            name: character.name,
            level: character.level,
            race: character.race?.name ?? "",
            origin: character.origin?.name ?? "",
            size: character.size,
            strength: character.strength,
            dexterity: character.dexterity,
            constitution: character.constitution,
            intelligence: character.intelligence,
            wisdom: character.wisdom,
            charisma: character.charisma,
            currentHitPoints: character.currentHitPoints,
            maximumHitPoints: character.maximumHitPoints,
            className: character.dndClass?.name,
            proficientSkills: character.proficientSkills,
            usedSpellSlots: usedSpellSlotsStringKeys,
            preparedSpellNames: character.preparedSpells.compactMap { $0.baseSpell?.name },
            inventoryItemNames: character.inventory.map { $0.name },
            equippedArmorName: character.equippedArmor?.name,
            equippedWeaponName: character.equippedWeapon?.name,
            equippedShieldName: character.equippedShield?.name,
            gold: character.gold,
            profileImageBase64: profileImageBase64,
            exportDate: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        return try encoder.encode(characterJSON)
    }
    
    /// Sauvegarde un personnage exporté dans un fichier
    /// - Parameters:
    ///   - character: Le personnage à exporter
    ///   - url: L'URL où sauvegarder le fichier
    @MainActor
    static func exportCharacterToFile(_ character: Character, to url: URL) throws {
        let data = try exportCharacter(character)
        try data.write(to: url)
    }
    
    // MARK: - Import
    
    /// Importe un personnage depuis des données JSON
    /// - Parameters:
    ///   - data: Les données JSON
    ///   - context: Le ModelContext pour créer le personnage
    /// - Returns: Le personnage importé
    @MainActor
    static func importCharacter(from data: Data, context: ModelContext) throws -> Character {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let characterJSON = try decoder.decode(CharacterJSON.self, from: data)
        
        // Trouver la classe par son nom
        let classFetchDescriptor = FetchDescriptor<DnDClass>(
            predicate: #Predicate<DnDClass> { $0.name == characterJSON.className ?? "" }
        )
        let dndClass = try? context.fetch(classFetchDescriptor).first
        
        // Trouver la race par son nom
        let raceFetchDescriptor = FetchDescriptor<Race>(
            predicate: #Predicate<Race> { $0.name == characterJSON.race }
        )
        let race = try? context.fetch(raceFetchDescriptor).first
        
        let originFetchDescriptor = FetchDescriptor<Background>(
            predicate: #Predicate<Background> { $0.name == characterJSON.origin }
        )
        let origin = try? context.fetch(originFetchDescriptor).first
        
        // Convertir usedSpellSlots avec clés Int
        let usedSpellSlots = characterJSON.usedSpellSlots.reduce(into: [Int: Int]()) { result, pair in
            if let key = Int(pair.key) {
                result[key] = pair.value
            }
        }
        
        // Décoder l'image de profil depuis base64
        let profileImageData: Data? = characterJSON.profileImageBase64.flatMap {
            Data(base64Encoded: $0)
        }
        
        // Créer le personnage
        let character = Character(
            name: characterJSON.name,
            level: characterJSON.level,
            dndClass: dndClass,
            race: race,
            origin: origin,
            size: characterJSON.size,
            strength: characterJSON.strength,
            dexterity: characterJSON.dexterity,
            constitution: characterJSON.constitution,
            intelligence: characterJSON.intelligence,
            wisdom: characterJSON.wisdom,
            charisma: characterJSON.charisma,
            proficientSkills: characterJSON.proficientSkills,
            currentHitPoints: characterJSON.currentHitPoints,
            maximumHitPoints: characterJSON.maximumHitPoints,
            usedSpellSlots: usedSpellSlots,
            gold: characterJSON.gold
        )
        
        character.profileImageData = profileImageData
        
        // Récupérer les sorts préparés par leurs noms
        for spellName in characterJSON.preparedSpellNames {
            let spellDescriptor = FetchDescriptor<Spell>(
                predicate: #Predicate<Spell> { $0.name == spellName }
            )
            if let spell = try? context.fetch(spellDescriptor).first {
                character.prepareSpell(spell)
            }
        }
        
        // Récupérer les items d'inventaire par leurs noms
        for itemName in characterJSON.inventoryItemNames {
            let itemDescriptor = FetchDescriptor<Item>(
                predicate: #Predicate<Item> { $0.name == itemName }
            )
            if let item = try? context.fetch(itemDescriptor).first {
                character.inventory.append(item)
            }
        }
        
        // Récupérer l'équipement équipé
        if let armorName = characterJSON.equippedArmorName {
            let armorDescriptor = FetchDescriptor<Item>(
                predicate: #Predicate<Item> { $0.name == armorName }
            )
            character.equippedArmor = try? context.fetch(armorDescriptor).first
        }
        
        if let weaponName = characterJSON.equippedWeaponName {
            let weaponDescriptor = FetchDescriptor<Item>(
                predicate: #Predicate<Item> { $0.name == weaponName }
            )
            character.equippedWeapon = try? context.fetch(weaponDescriptor).first
        }
        
        if let shieldName = characterJSON.equippedShieldName {
            let shieldDescriptor = FetchDescriptor<Item>(
                predicate: #Predicate<Item> { $0.name == shieldName }
            )
            character.equippedShield = try? context.fetch(shieldDescriptor).first
        }
        
        context.insert(character)
        try context.save()
        
        return character
    }
    
    /// Importe un personnage depuis un fichier
    /// - Parameters:
    ///   - url: L'URL du fichier JSON
    ///   - context: Le ModelContext pour créer le personnage
    /// - Returns: Le personnage importé
    @MainActor
    static func importCharacter(from url: URL, context: ModelContext) throws -> Character {
        let data = try Data(contentsOf: url)
        return try importCharacter(from: data, context: context)
    }
}

// MARK: - Erreurs

enum CharacterImportExportError: LocalizedError {
    case invalidJSON
    case classNotFound
    case raceNotFound
    case spellNotFound(String)
    case itemNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "Le fichier JSON n'est pas valide"
        case .classNotFound:
            return "La classe du personnage n'a pas été trouvée"
        case .raceNotFound:
            return "La race du personnage n'a pas été trouvée"
        case .spellNotFound(let name):
            return "Le sort '\(name)' n'a pas été trouvé"
        case .itemNotFound(let name):
            return "L'objet '\(name)' n'a pas été trouvé"
        }
    }
}
