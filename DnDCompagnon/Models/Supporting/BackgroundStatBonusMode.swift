//
//  BackgroundStatBonusMode.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 16/07/2026.
//

import Foundation

enum BackgroundStatBonusMode: String, CaseIterable {
    case triplePlusOne = "+1/+1/+1"
    case doublePlusOne = "+2/+1"
    
    var displayName: String {
        self.rawValue
    }
}
