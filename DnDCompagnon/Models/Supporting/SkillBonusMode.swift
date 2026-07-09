//
//  SkillBonusMode.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import Foundation

/// Modes de bonus pour une compétence
enum SkillBonusMode: Hashable {
    case none
    case fixed(Int)
    case stat(String)
}
