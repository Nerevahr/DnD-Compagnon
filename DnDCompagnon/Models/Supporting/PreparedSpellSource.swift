//
//  PreparedSpellSource.swift
//  DnDCompagnon
//

import Foundation
import SwiftUI

/// Origine d'un sort préparé : progression normale de la classe, don, ou aptitude de classe
enum PreparedSpellSource: String, Codable, CaseIterable, Hashable {
    case classe
    case don
    case aptitude

    var displayName: String {
        switch self {
        case .classe:
            return "Classe"
        case .don:
            return "Don"
        case .aptitude:
            return "Aptitude"
        }
    }

    var color: Color {
        switch self {
        case .classe:
            return .gray
        case .don:
            return .orange
        case .aptitude:
            return .teal
        }
    }
}
