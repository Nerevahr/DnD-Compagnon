//
//  HitDie.swift
//  DnDCompagnon
//

import Foundation

/// Dé de vie d'une classe, utilisé pour déterminer les points de vie gagnés à la montée de niveau.
enum HitDie: Int, Codable, CaseIterable, Identifiable {
    case d4 = 4
    case d6 = 6
    case d8 = 8
    case d10 = 10
    case d12 = 12
    case d20 = 20

    var id: Int { rawValue }

    /// Libellé affiché, ex. "d8"
    var label: String { "d\(rawValue)" }
}
