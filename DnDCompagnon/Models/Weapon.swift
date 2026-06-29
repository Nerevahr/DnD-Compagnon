//
//  Weapon.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 16/06/2026.
//

import Foundation
import SwiftData

@Model
final class Weapon {
    var id = UUID()
    var name: String
    var weaponDescription: String
    var imageData: Data?
    var weaponType: WeaponType?
    var damageDice: String?
    var damageType: DamageType?
    
    init(
        name: String,
        weaponDescription: String = "",
        imageData: Data? = nil,
        weaponType: WeaponType? = nil,
        damageDice: String? = nil,
        damageType: DamageType? = nil
    ) {
        self.name = name
        self.weaponDescription = weaponDescription
        self.imageData = imageData
        self.weaponType = weaponType
        self.damageDice = damageDice
        self.damageType = damageType
    }
}
