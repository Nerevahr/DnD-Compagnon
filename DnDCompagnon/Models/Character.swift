//
//  Character.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

@Model
final class Character {
    var timestamp: Date
    var name: String
    var level: Int
    
    // Relation vers la classe
    var dndClass: DnDClass?
    @Relationship(deleteRule: .nullify) var race: Race?
    @Relationship(deleteRule: .nullify) var origin: Background?
    var size: String // Catégorie de taille (Petit, Moyen, Grand, etc.)
    
    // Stats de base (scores de caractéristiques)
    var strength: Int
    var dexterity: Int
    var constitution: Int
    var intelligence: Int
    var wisdom: Int
    var charisma: Int
    
    // Points de vie
    var currentHitPoints: Int
    var maximumHitPoints: Int
    
    // Historique des PV gagnés par niveau (clé: niveau, valeur: PV gagnés)
    var hpLevelHistory: [Int: Int] = [:]
    
    // Compétences maîtrisées par le personnage (liste des noms)
    var proficientSkills: [String]
    
    // Emplacements de sorts utilisés par niveau
    var usedSpellSlots: [Int: Int] = [:]
    
    // Sorts préparés (relation vers les sorts)
    @Relationship(deleteRule: .nullify) var preparedSpells: [PreparedSpell]

    // Équipement équipé
    @Relationship(deleteRule: .nullify) var equippedArmor: Item?
    @Relationship(deleteRule: .nullify) var equippedWeapon: Item?
    @Relationship(deleteRule: .nullify) var equippedShield: Item?
    // Inventaire du personnage
    @Relationship(deleteRule: .nullify) var inventory: [Item]
    var gold: Double = 0.0
    
    // Dons du personnage
    @Relationship(deleteRule: .nullify) var feats: [Feat] = []
    
    @Attribute(.externalStorage) var profileImageData: Data?
    
    // MARK: - Computed Properties - Stats de base
    
    /// Modificateurs calculés
    var strengthModifier: Int {
        calculateModifier(for: strength)
    }
    
    var dexterityModifier: Int {
        calculateModifier(for: dexterity)
    }
    
    var constitutionModifier: Int {
        calculateModifier(for: constitution)
    }
    
    var intelligenceModifier: Int {
        calculateModifier(for: intelligence)
    }
    
    var wisdomModifier: Int {
        calculateModifier(for: wisdom)
    }
    
    var charismaModifier: Int {
        calculateModifier(for: charisma)
    }
    
    // MARK: - Computed Properties - Combat & Défense
    
    /// Bonus de maîtrise basé sur le niveau
    var proficiencyBonus: Int {
        2 + (level - 1) / 4
    }
    
    /// Initiative (modificateur de Dextérité)
     var initiative: Int {
         dexterityModifier
     }
     
    // Perception passive (10 + modificateur de Sagesse + bonus de maîtrise si Perception est maîtrisée)
    var passivePerception: Int {
        let perceptionSkill = Character.allSkills.first { $0.name == "Perception" }!
        return 10 + skillModifier(for: perceptionSkill)
    }
    
    /// Classe d'Armure (CA)
    /// Formule : selon la catégorie d'armure + bonus de bouclier
    var armorClass: Int {
        var ca: Int
        
        if let armor = equippedArmor,
           let category = armor.armorCategory,
           let baseCA = armor.baseArmorClass {
            // Armure équipée
            switch category {
            case .vetement:
                // Vêtement : 10 + Dex
                ca = 10 + dexterityModifier
                
            case .legere:
                // Armure légère : CA de base + Dex complet
                ca = baseCA + dexterityModifier
                
            case .moyenne:
                // Armure moyenne : CA de base + Dex (max +2)
                ca = baseCA + min(dexterityModifier, 2)
                
            case .lourde:
                // Armure lourde : CA fixe (pas de bonus Dex)
                ca = baseCA
            }
        } else {
            // Pas d'armure : 10 + Dex
            ca = 10 + dexterityModifier
        }
        
        // Bonus du bouclier (+2 CA)
        if equippedShield != nil {
            ca += 2
        }
        
        return ca
    }
    
    /// Vitesse en pieds (1 case = 5 pieds)
    /// Pour l'instant : 30 pieds par défaut (9m)
    /// TODO: Gérer les modificateurs de race, sorts, etc.
    var speed: Int {
        30 // pieds
    }
    
    /// Vitesse en mètres (pour affichage)
    var speedInMeters: String {
        "\(speed / 5 * 3 / 2)m" // Conversion approximative
    }
    
    // MARK: - Computed Properties - Incantation
    
    /// DD des sorts (Difficulté)
    /// Formule : 8 + bonus de maîtrise + modificateur de caractéristique d'incantation
    var spellSaveDC: Int? {
        guard let ability = dndClass?.spellcastingAbility,
              !ability.isEmpty else { return nil }
        return 8 + proficiencyBonus + getModifier(for: ability)
    }
    
    /// Bonus d'attaque des sorts
    /// Formule : bonus de maîtrise + modificateur de caractéristique d'incantation
    var spellAttackBonus: Int? {
        guard let ability = dndClass?.spellcastingAbility,
              !ability.isEmpty else { return nil }
        return proficiencyBonus + getModifier(for: ability)
    }
    
    /// Bonus d'attaque des sorts formaté (+X)
    var spellAttackBonusFormatted: String? {
        guard let bonus = spellAttackBonus else { return nil }
        return bonus >= 0 ? "+\(bonus)" : "\(bonus)"
    }
    
    // MARK: - Points de vie
    
    /// Points de vie maximum
    /// TODO: Implémenter le calcul basé sur la classe et le niveau
    var maxHitPoints: Int {
        // Formule basique : DV de classe au niveau 1 + (niveau - 1) * (moyenne DV + mod Constitution)
        // Pour l'instant, valeur par défaut
        return 10 + (level - 1) * (5 + constitutionModifier)
    }
    
    // MARK: - Methods - Calculs
    
    /// Calcule le modificateur d'une caractéristique
    /// Formule D&D 5e : (score - 10) / 2 (arrondi vers le bas)
    private func calculateModifier(for score: Int) -> Int {
        (score - 10) / 2
    }
    
    /// Méthode pour calculer un jet de sauvegarde
    func savingThrow(for stat: String) -> Int {
        let modifier = getModifier(for: stat)
        let isProficient = dndClass?.masteredStats.contains(stat) ?? false
        return modifier + (isProficient ? proficiencyBonus : 0)
    }
    
    /// Méthode pour calculer le modificateur d'une compétence
    func skillModifier(for skill: DnDSkill) -> Int {
        let statModifier = getModifier(for: skill.baseStat)
        let isProficient = proficientSkills.contains(skill.name)
        return statModifier + (isProficient ? proficiencyBonus : 0)
    }
    
    /// Méthode pour obtenir le modificateur d'une stat par nom
    func getModifier(for stat: String) -> Int {
        switch stat {
        case "Force": return strengthModifier
        case "Dextérité": return dexterityModifier
        case "Constitution": return constitutionModifier
        case "Intelligence": return intelligenceModifier
        case "Sagesse": return wisdomModifier
        case "Charisme": return charismaModifier
        default: return 0
        }
    }
    
    // MARK: - Initializer
    
    init(
        timestamp: Date = Date(),
        name: String,
        level: Int = 1,
        dndClass: DnDClass? = nil,
        race: Race? = nil,
        origin: Background? = nil,
        size: String = "Moyen",
        strength: Int = 10,
        dexterity: Int = 10,
        constitution: Int = 10,
        intelligence: Int = 10,
        wisdom: Int = 10,
        charisma: Int = 10,
        proficientSkills: [String] = [],
        preparedSpells: [PreparedSpell] = [],
        inventory: [Item] = [],  // Ajouter cette ligne
        equippedArmor: Item? = nil,
        equippedWeapon: Item? = nil,
        equippedShield: Item? = nil,
        currentHitPoints: Int? = nil,
        maximumHitPoints: Int? = nil,
        usedSpellSlots: [Int: Int] = [:],
        gold: Double = 0.0
    ) {
        self.timestamp = timestamp
        self.name = name
        self.level = level
        self.dndClass = dndClass
        self.race = race
        self.origin = origin
        self.size = size
        self.strength = strength
        self.dexterity = dexterity
        self.constitution = constitution
        self.intelligence = intelligence
        self.wisdom = wisdom
        self.charisma = charisma
        self.proficientSkills = proficientSkills
        self.preparedSpells = preparedSpells
        self.inventory = inventory  // Ajouter cette ligne
        self.equippedArmor = equippedArmor
        self.equippedWeapon = equippedWeapon
        self.equippedShield = equippedShield
        // Calcul des PV par défaut : 8 + modificateur de Constitution
        let constitutionMod = (constitution - 10) / 2
        let defaultMaxHP = 8 + constitutionMod
        let finalMaxHP = maximumHitPoints ?? defaultMaxHP

        // Initialiser les deux propriétés sans référence à self
        self.maximumHitPoints = finalMaxHP
        self.currentHitPoints = currentHitPoints ?? finalMaxHP
        self.usedSpellSlots = usedSpellSlots // ✅ Initialisation
        self.gold = gold
    }
}

// MARK: - Static Data

extension Character {
    /// Liste de toutes les compétences disponibles en D&D 5e
    static let allSkills: [DnDSkill] = DnDSkill.allSkills
    
    /// Noms des 6 caractéristiques principales
    static let abilityScores = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
}

// MARK: - Spell Slots Management

extension Character {
    /// Retourne les emplacements de sorts disponibles pour ce personnage
    var availableSpellSlots: [Int: Int] {
        return dndClass?.spellSlots(at: level) ?? [:]
    }
    
    /// Retourne le nombre d'emplacements totaux pour un niveau de sort donné
    func spellSlotCount(for spellLevel: Int) -> Int {
        return dndClass?.spellSlotCount(characterLevel: level, spellLevel: spellLevel) ?? 0
    }
    
    /// Retourne le nombre d'emplacements utilisés pour un niveau de sort donné
    func usedSpellSlotCount(for spellLevel: Int) -> Int {
        return usedSpellSlots[spellLevel] ?? 0
    }
    
    /// Retourne le nombre d'emplacements restants pour un niveau de sort donné
    func remainingSpellSlots(for spellLevel: Int) -> Int {
        let total = spellSlotCount(for: spellLevel)
        let used = usedSpellSlotCount(for: spellLevel)
        return max(0, total - used)
    }
    
    /// Utilise un emplacement de sort
    func useSpellSlot(level: Int) {
        let current = usedSpellSlots[level] ?? 0
        let max = spellSlotCount(for: level)
        if current < max {
            usedSpellSlots[level] = current + 1
        }
    }
    
    /// Restaure un emplacement de sort
    func restoreSpellSlot(level: Int) {
        let current = usedSpellSlots[level] ?? 0
        if current > 0 {
            usedSpellSlots[level] = current - 1
        }
    }
    
    /// Restaure tous les emplacements de sorts (repos long)
    func restoreAllSpellSlots() {
        usedSpellSlots = [:]
    }
}

// MARK: - Prepared Spells Management

extension Character {
    /// Retourne les sorts préparés groupés par niveau
    var preparedSpellsByLevel: [Int: [PreparedSpell]] {
        let validSpells = preparedSpells.filter { $0.baseSpell != nil }
        return Dictionary(grouping: validSpells) { preparedSpell in
            preparedSpell.baseSpell?.niveau ?? 0
        }
    }
    
    /// Ajoute un sort à la liste des sorts préparés
    func prepareSpell(_ spell: Spell) {
        let preparedSpell = PreparedSpell(baseSpell: spell)
        preparedSpells.append(preparedSpell)
    }
    
    /// Retire un sort préparé
    func unprepareSpell(_ preparedSpell: PreparedSpell) {
        if let index = preparedSpells.firstIndex(of: preparedSpell) {
            preparedSpells.remove(at: index)
        }
    }
    
    /// Vérifie si un sort est déjà préparé
    func isSpellPrepared(_ spell: Spell) -> Bool {
        preparedSpells.contains { $0.baseSpell?.persistentModelID == spell.persistentModelID }
    }
}

// MARK: - Feats Management

extension Character {
    /// Ajoute un don au personnage
    func addFeat(_ feat: Feat) {
        if !feats.contains(feat) {
            feats.append(feat)
        }
    }
    
    /// Retire un don du personnage
    func removeFeat(_ feat: Feat) {
        feats.removeAll { $0.id == feat.id }
    }
    
    /// Vérifie si un don est déjà attribué au personnage
    func hasFeat(_ feat: Feat) -> Bool {
        feats.contains { $0.id == feat.id }
    }
    
    /// Assigne une nouvelle origine et synchronise son don d'origine
    /// Retire le don de l'ancienne origine (si présent) et ajoute celui de la nouvelle
    func setOrigin(_ newOrigin: Background?) {
        // Retirer le don d'origine de l'ancienne origine
        if let oldFeat = origin?.originFeat {
            removeFeat(oldFeat)
        }
        
        // Assigner nouvelle origine
        origin = newOrigin
        
        // Ajouter le don d'origine de la nouvelle origine
        if let newFeat = newOrigin?.originFeat {
            addFeat(newFeat)
        }
    }
}

// MARK: - Level and HP Management

extension Character {
    /// Augmente le niveau du personnage et enregistre les PV gagnés
    /// - Parameter dieRoll: Résultat du dé de gain de PV
    func levelUp(dieRoll: Int) {
        // Valider que le niveau n'est pas déjà au maximum
        guard level < 20 else { return }
        
        // Sauvegarder l'ancien niveau pour la validation
        let previousLevel = level
        
        // Calculer le gain de PV : dé + modificateur de Constitution, minimum 1
        let hpGain = max(1, dieRoll + constitutionModifier)
        
        // Augmenter le niveau
        level += 1
        
        // Validation: vérifier que le niveau a bien augmenté
        assert(level == previousLevel + 1, "Level increment failed: \(previousLevel) -> \(level)")
        
        // Enregistrer le gain dans l'historique
        hpLevelHistory[level] = hpGain
        
        // Validation: vérifier que l'historique a bien enregistré la valeur
        assert(hpLevelHistory[level] == hpGain, "HP history recording failed at level \(level)")
        
        // Augmenter les PV max
        maximumHitPoints += hpGain
        
        // Augmenter les PV actuels du même montant (restauration partielle)
        currentHitPoints = min(currentHitPoints + hpGain, maximumHitPoints)
        
        // Diagnostique pour le débogage
        print("✅ Level Up Success: Lvl \(level), HP Gain: \(hpGain), Max HP: \(maximumHitPoints), History: \(hpLevelHistory)")
    }
    
    /// Diminue le niveau du personnage et retire les PV correspondants
    /// - Retourne `true` si la descente a réussi, `false` si le niveau est déjà 1
    @discardableResult
    func levelDown() -> Bool {
        guard level > 1 else { return false }
        
        let previousLevel = level
        
        // Récupérer le gain de PV du niveau actuel AVANT de le diminuer
        if let hpGain = hpLevelHistory[level] {
            // Retirer les PV max
            maximumHitPoints = max(1, maximumHitPoints - hpGain)
            
            // Retirer les PV actuels (sans descendre en dessous de 1)
            currentHitPoints = min(currentHitPoints, maximumHitPoints)
            
            // Supprimer l'entrée de l'historique
            hpLevelHistory.removeValue(forKey: level)
        }
        
        // Diminuer le niveau
        level -= 1
        
        // Validation
        assert(level == previousLevel - 1, "Level decrement failed: \(previousLevel) -> \(level)")
        
        print("✅ Level Down Success: Lvl \(level), Max HP: \(maximumHitPoints), History: \(hpLevelHistory)")
        
        return true
    }
}

// MARK: - Validation & Debugging

extension Character {
    /// Valide la cohérence des données du personnage
    /// Retourne un message d'erreur si des incohérences sont détectées
    func validateIntegrity() -> String? {
        // Vérifier que le niveau est dans les limites valides
        if level < 1 || level > 20 {
            return "❌ Niveau invalide: \(level) (doit être entre 1 et 20)"
        }
        
        // Vérifier que les PV max sont positifs
        if maximumHitPoints < 1 {
            return "❌ PV max invalides: \(maximumHitPoints) (doit être > 0)"
        }
        
        // Vérifier que les PV actuels ne dépassent pas les PV max
        if currentHitPoints > maximumHitPoints {
            return "❌ PV actuels (\(currentHitPoints)) > PV max (\(maximumHitPoints))"
        }
        
        // Vérifier que l'historique n'a pas d'entrées pour les niveaux impossibles
        for (histLevel, _) in hpLevelHistory {
            if histLevel < 2 || histLevel > 20 {
                return "❌ Entrée d'historique invalide au niveau \(histLevel)"
            }
        }
        
        // Vérifier que toutes les entrées d'historique sont positives
        for (_, hpGain) in hpLevelHistory {
            if hpGain < 1 {
                return "❌ Gain de PV invalide: \(hpGain) (doit être > 0)"
            }
        }
        
        // ✅ Tout est valide
        return nil
    }
    
    /// Affiche un rapport de diagnostic complet
    func printDiagnostics() {
        print("""
        === CHARACTER DIAGNOSTICS ===
        Name: \(name)
        Level: \(level)
        Max HP: \(maximumHitPoints)
        Current HP: \(currentHitPoints)
        HP History: \(hpLevelHistory)
        Constitution Modifier: \(constitutionModifier)
        """)
        
        if let error = validateIntegrity() {
            print("⚠️  VALIDATION ERROR: \(error)")
        } else {
            print("✅ All validations passed")
        }
    }
}
