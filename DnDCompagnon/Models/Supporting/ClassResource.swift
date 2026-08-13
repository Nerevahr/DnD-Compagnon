//
//  ClassResource.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/08/2026.
//

import Foundation

/// Structure pour représenter une ressource de classe (ex: Canalisation d'énergie divine)
struct ClassResource: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    // Dictionnaire : [niveau de personnage: quantité disponible]
    var amountsByLevel: [Int: Int]

    init(name: String, amountsByLevel: [Int: Int] = [:]) {
        self.name = name
        self.amountsByLevel = amountsByLevel
    }

    /// Retourne la quantité disponible pour un niveau de personnage donné
    /// (en tenant compte du dernier palier atteint, comme pour les emplacements de sorts)
    func amount(at characterLevel: Int) -> Int {
        amountsByLevel[characterLevel] ?? amountsByLevel
            .filter { $0.key <= characterLevel }
            .max { $0.key < $1.key }?.value ?? 0
    }
}
