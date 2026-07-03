//
//  MockData.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 16/06/2026.
//

import Foundation

/// Données fictives pour les previews et tests
struct MockData {
    
    // MARK: - Races
    
    static let humanRace = Race(
        name: "Humain",
        abilities: [
            RaceAbility(name: "Polyvalence", description: "+1 à toutes les caractéristiques")
        ],
        abilityBonuses: [
            "Force": 1, "Dextérité": 1, "Constitution": 1,
            "Intelligence": 1, "Sagesse": 1, "Charisme": 1
        ],
        speed: 30,
        defaultSize: "Moyen"
    )
    
    static let elfRace = Race(
        name: "Elfe",
        abilities: [
            RaceAbility(name: "Vision dans le noir", description: "Vision à 60 pieds dans le noir"),
            RaceAbility(name: "Sens aiguisés", description: "Maîtrise de la compétence Perception"),
            RaceAbility(name: "Ascendance féerique", description: "Avantage aux jets de sauvegarde contre la magie de charme")
        ],
        abilityBonuses: ["Dextérité": 2],
        speed: 30,
        defaultSize: "Moyen"
    )
    
    static let dwarfRace = Race(
        name: "Nain",
        abilities: [
            RaceAbility(name: "Vision dans le noir", description: "Vision à 60 pieds dans le noir"),
            RaceAbility(name: "Résistance naine", description: "Avantage aux jets de sauvegarde contre le poison"),
            RaceAbility(name: "Formation aux armes naines", description: "Maîtrise des armes naines")
        ],
        abilityBonuses: ["Constitution": 2],
        speed: 25,
        defaultSize: "Moyen"
    )
    
    // MARK: - Classes
    
    static let wizardClass = DnDClass(
        name: "Magicien",
        descriptionClass: "Lanceur de sorts arcanique",
        masteredStats: ["Intelligence", "Sagesse"],
        spellcastingAbility: "Intelligence",
        spellSlots: [
            1: [1: 2],
            2: [1: 3],
            3: [1: 4, 2: 2],
            4: [1: 4, 2: 3],
            5: [1: 4, 2: 3, 3: 2]
        ]
    )
    
    static let fighterClass = DnDClass(
        name: "Guerrier",
        descriptionClass: "Maître des armes",
        masteredStats: ["Force", "Constitution"]
    )
    
    // MARK: - Items (Armes)
    
    static let longsword = Item(
        name: "Épée longue",
        itemDescription: "Une lame acérée et équilibrée",
        type: .arme,
        weaponType: .martialMelee,
        damageDice: "1d8",
        damageType: .slashing
    )
    
    static let dagger = Item(
        name: "Dague",
        itemDescription: "Une lame courte et versatile",
        type: .arme,
        weaponType: .simpleMelee,
        damageDice: "1d4",
        damageType: .piercing
    )
    
    static let shortbow = Item(
        name: "Arc court",
        itemDescription: "Un arc léger pour le tir rapide",
        type: .arme,
        weaponType: .simpleRanged,
        damageDice: "1d6",
        damageType: .piercing
    )
    
    static let greatsword = Item(
        name: "Épée à deux mains",
        itemDescription: "Une lame massive et puissante",
        type: .arme,
        weaponType: .martialMelee,
        damageDice: "2d6",
        damageType: .slashing
    )
    
    // MARK: - Items (Armures)
    
    static let leatherArmor = Item(
        name: "Armure de cuir",
        itemDescription: "Une armure légère et flexible",
        type: .armure,
        armorCategory: .legere,
        baseArmorClass: 11
    )
    
    static let chainmail = Item(
        name: "Cotte de mailles",
        itemDescription: "Une armure de mailles métalliques",
        type: .armure,
        armorCategory: .lourde,
        baseArmorClass: 16
    )
    
    static let shield = Item(
        name: "Bouclier",
        itemDescription: "Un bouclier rond en bois",
        type: .bouclier
    )
    
    // MARK: - Spells (Tours de magie offensifs)
    
    static let fireBolt = Spell(
        timestamp: Date(),
        name: "Trait de feu",
        portee: "36 mètres",
        ecole: "Évocation",
        componentV: true,
        componentS: true,
        componentM: false,
        dureeIncantation: "1 action",
        duree: "Instantanée",
        niveau: 0,
        classes: ["Magicien", "Ensorceleur"],
        concentration: false,
        descriptionSort: "Un rayon de feu frappe une cible",
        isOffensive: true,
        requiresSavingThrow: false,
        damageAmount: "1d10"
    )
    
    static let rayOfFrost = Spell(
        timestamp: Date(),
        name: "Rayon de givre",
        portee: "18 mètres",
        ecole: "Évocation",
        componentV: true,
        componentS: true,
        componentM: false,
        dureeIncantation: "1 action",
        duree: "Instantanée",
        niveau: 0,
        classes: ["Magicien", "Ensorceleur"],
        concentration: false,
        descriptionSort: "Un rayon de froid glacial ralentit la cible",
        isOffensive: true,
        requiresSavingThrow: true,
        savingThrowStat: "Constitution",
        damageAmount: "1d8"
    )
    
    static let shockingGrasp = Spell(
        timestamp: Date(),
        name: "Poigne électrique",
        portee: "Contact",
        ecole: "Évocation",
        componentV: true,
        componentS: true,
        componentM: false,
        dureeIncantation: "1 action",
        duree: "Instantanée",
        niveau: 0,
        classes: ["Magicien", "Ensorceleur"],
        concentration: false,
        descriptionSort: "De l'électricité surgit de votre main pour électrocuter une créature",
        isOffensive: true,
        requiresSavingThrow: false,
        damageAmount: "1d8"
    )
    
    // MARK: - Spells (Sorts de niveau supérieur)
    
    static let magicMissile = Spell(
        timestamp: Date(),
        name: "Projectile magique",
        portee: "36 mètres",
        ecole: "Évocation",
        componentV: true,
        componentS: true,
        componentM: false,
        dureeIncantation: "1 action",
        duree: "Instantanée",
        niveau: 1,
        classes: ["Magicien", "Ensorceleur"],
        concentration: false,
        descriptionSort: "Trois projectiles magiques frappent automatiquement leur cible",
        isOffensive: true,
        requiresSavingThrow: false,
        damageAmount: "3d4+3"
    )
    
    static let shieldSpell = Spell(
        timestamp: Date(),
        name: "Bouclier",
        portee: "Personnelle",
        ecole: "Abjuration",
        componentV: true,
        componentS: true,
        componentM: false,
        dureeIncantation: "1 réaction",
        duree: "1 round",
        niveau: 1,
        classes: ["Magicien", "Ensorceleur"],
        concentration: false,
        descriptionSort: "Une barrière invisible vous protège, ajoutant +5 à la CA",
        isOffensive: false
    )
    
    // MARK: - Helper pour créer des PreparedSpells
    
    /// Crée un PreparedSpell à partir d'un Spell
    private static func prepareSpell(_ spell: Spell) -> PreparedSpell {
        PreparedSpell(baseSpell: spell)
    }
    
    /// Crée un PreparedSpell avec des valeurs personnalisées
    private static func prepareSpellWithCustomDamage(_ spell: Spell, customDamage: String) -> PreparedSpell {
        PreparedSpell(baseSpell: spell, customDamageAmount: customDamage)
    }
    
    // MARK: - Characters

    static let wizard = Character(
        name: "Gandalf",
        level: 3,
        dndClass: wizardClass,
        origin: nil,
        strength: 10,
        dexterity: 14,
        constitution: 12,
        intelligence: 18,
        wisdom: 13,
        charisma: 10,
        proficientSkills: ["Arcanes", "Histoire", "Investigation", "Religion"],
        preparedSpells: [
            prepareSpell(fireBolt),
            prepareSpell(rayOfFrost),
            prepareSpellWithCustomDamage(shockingGrasp, customDamage: "2d8"),
            prepareSpell(magicMissile),
            prepareSpell(shieldSpell)
        ],
        inventory: [longsword, dagger, shortbow, leatherArmor]
    )

    static let fighter = Character(
        name: "Conan",
        level: 5,
        dndClass: fighterClass,
        origin: nil,
        strength: 18,
        dexterity: 14,
        constitution: 16,
        intelligence: 10,
        wisdom: 12,
        charisma: 8,
        proficientSkills: ["Athlétisme", "Intimidation", "Survie"],
        preparedSpells: [],
        inventory: [greatsword, longsword, dagger, chainmail, shield],
        equippedArmor: chainmail,
        equippedWeapon: greatsword
    )
    /// Configure un personnage avec une arme équipée
    static func wizardWithEquippedWeapon() -> Character {
        let char = wizard
        char.equippedWeapon = longsword
        return char
    }
}
