//
//  SpellSeeder.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

enum SpellSeeder {

    /// Insère les sorts de base uniquement si la base est vide.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        // On vérifie s'il existe déjà des sorts
        let descriptor = FetchDescriptor<Spell>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // --- Insertion des sorts ---
        for spell in defaultSpells {
            context.insert(spell)
        }

        try? context.save()
    }

    // MARK: - Données de base

    private static var defaultSpells: [Spell] {
        [
            Spell(
                timestamp: Date(),
                name: "Boule de feu",
                portee: "150 mètres",
                ecole: "Évocation",
                componentV: true,
                componentS: true,
                componentM: true,
                materialDescription: "Une petite boule de guano de chauve-souris et du soufre",
                dureeIncantation: "1 action",
                niveau: 3,
                classes: ["Ensorceleur", "Magicien"],
                concentration: false,
                descriptionSort: "Un point lumineux jaillit de votre doigt vers un point que vous choisissez à portée, puis se dilate en une explosion avec un grondement sourd. Chaque créature dans une sphère de 6 mètres de rayon centrée sur ce point doit réussir un jet de sauvegarde de Dextérité. Une cible subit 8d6 dégâts de feu en cas d'échec, ou la moitié en cas de succès."
            ),
            Spell(
                timestamp: Date(),
                name: "Soin des blessures",
                portee: "Contact",
                ecole: "Évocation",
                componentV: true,
                componentS: true,
                componentM: false,
                dureeIncantation: "1 action",
                niveau: 1,
                classes: ["Barde", "Clerc", "Druide", "Paladin", "Ranger"],
                concentration: false,
                descriptionSort: "Une créature que vous touchez récupère un nombre de points de vie égal à 1d8 + votre modificateur de caractéristique d'incantation. Ce sort est sans effet sur les morts-vivants et les artificiels."
            ),
            Spell(
                timestamp: Date(),
                name: "Bouclier",
                portee: "Personnelle",
                ecole: "Abjuration",
                componentV: true,
                componentS: true,
                componentM: false,
                dureeIncantation: "1 réaction",
                niveau: 1,
                classes: ["Magicien", "Ensorceleur"],
                concentration: false,
                descriptionSort: "Une barrière magique invisible apparaît et vous protège. Jusqu'au début de votre prochain tour, vous bénéficiez d'un bonus de +5 à la CA, y compris contre l'attaque déclenchante, et vous ne subissez aucun dégât du sort projectile magique."
            ),
            Spell(
                timestamp: Date(),
                name: "Projectile magique",
                portee: "120 mètres",
                ecole: "Évocation",
                componentV: true,
                componentS: true,
                componentM: false,
                dureeIncantation: "1 action",
                niveau: 1,
                classes: ["Ensorceleur", "Magicien"],
                concentration: false,
                descriptionSort: "Vous créez trois dards de force magique. Chaque dard touche une créature de votre choix à portée. Un dard inflige 1d4+1 dégâts de force à sa cible. Les dards frappent tous simultanément, et vous pouvez les diriger vers une ou plusieurs cibles."
            ),
            Spell(
                timestamp: Date(),
                name: "Invisibilité",
                portee: "Contact",
                ecole: "Illusion",
                componentV: true,
                componentS: true,
                componentM: true,
                materialDescription: "Un cil enveloppé dans une gomme de gomme arabique",
                dureeIncantation: "1 action",
                niveau: 2,
                classes: ["Barde", "Ensorceleur", "Magicien", "Sorcier"],
                concentration: true,
                descriptionSort: "Une créature que vous touchez devient invisible jusqu'à la fin du sort. Tout ce que la cible porte est invisible tant qu'il reste sur elle. Le sort prend fin pour une cible qui attaque ou lance un sort."
            ),
            Spell(
                timestamp: Date(),
                name: "Détection de la magie",
                portee: "Personnelle",
                ecole: "Divination",
                componentV: true,
                componentS: true,
                componentM: false,
                dureeIncantation: "1 action",
                niveau: 1,
                classes: ["Barde", "Clerc", "Druide", "Magicien", "Paladin", "Ranger", "Ensorceleur", "Sorcier"],
                concentration: true,
                descriptionSort: "Pendant la durée du sort, vous percevez la présence de la magie dans un rayon de 9 mètres. Si vous percevez ainsi de la magie, vous pouvez utiliser une action pour discerner les auras entourant les objets ou créatures magiques visibles. Vous apprenez alors l'école de magie de chacun."
            ),
            Spell(
                timestamp: Date(),
                name: "Lumières dansantes",
                portee: "36 mètres",
                ecole: "Évocation",
                componentV: true,
                componentS: true,
                componentM: true,
                materialDescription: "Un peu de phosphore ou de pourriture des bois",
                dureeIncantation: "1 action",
                niveau: 0,
                classes: ["Barde", "Ensorceleur", "Magicien"],
                concentration: true,
                descriptionSort: "Vous créez jusqu'à quatre lumières de la taille d'une torche à portée. Chacune éclaire dans un rayon de 1,50 mètre. Vous pouvez les déplacer de 18 mètres par action bonus."
            ),
            Spell(
                timestamp: Date(),
                name: "Convocation d'animaux",
                portee: "18 mètres",
                ecole: "Conjuration",
                componentV: true,
                componentS: true,
                componentM: false,
                dureeIncantation: "1 action",
                niveau: 3,
                classes: ["Druide", "Ranger"],
                concentration: true,
                descriptionSort: "Vous invoquez des esprits féeriques qui prennent la forme d'animaux. Choisissez une option : un animal de FP 2 ou inférieur, deux animaux de FP 1 ou inférieur, ou quatre animaux de FP 1/2 ou inférieur. Chaque animal disparaît quand il tombe à 0 point de vie ou quand le sort prend fin."
            ),
        ]
    }
}
