//
//  FeatType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation
import SwiftUI

/// Énumération des types de dons en D&D 5e
enum FeatType: String, Codable, CaseIterable, Hashable {
    case origine = "don d'origine"
    case general = "don général"
    case styleDeCombat = "don de style de combat"
    case faveurEpique = "don de faveur épique"
    
    var displayName: String {
        switch self {
        case .origine:
            return "Don d'origine"
        case .general:
            return "Don général"
        case .styleDeCombat:
            return "Don de style de combat"
        case .faveurEpique:
            return "Don de faveur épique"
        }
    }
    
    var color: Color {
        switch self {
        case .origine:
            return .purple
        case .general:
            return .green
        case .styleDeCombat:
            return .red
        case .faveurEpique:
            return .yellow
        }
    }
}
