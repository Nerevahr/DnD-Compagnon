//
//  Item.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var text: String // Ajout de la propriété pour le texte
    
    init(timestamp: Date, text: String) {
        self.timestamp = timestamp
        self.text = text
    }
}
