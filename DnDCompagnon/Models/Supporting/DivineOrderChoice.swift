//
//  DivineOrderChoice.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import Foundation

/// Choix offert par l'aptitude de Clerc "Ordre divin" au niveau 1
enum DivineOrderChoice: String, CaseIterable {
    case protecteur = "Protecteur"
    case thaumaturge = "Thaumaturge"

    var displayName: String {
        self.rawValue
    }
}
