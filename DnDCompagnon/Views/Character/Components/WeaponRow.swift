//
//  WeaponRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 17/06/2026.
//

import SwiftUI

struct WeaponRow: View {
    let character: Character
    let weapon: Item
    
    var isEquipped: Bool {
        character.equippedWeapon == weapon
    }
    
    // Calcul du bonus d'attaque
    var attackBonus: Int {
        if weapon.weaponType == .simpleRanged || weapon.weaponType == .martialRanged {
            return character.dexterityModifier + character.proficiencyBonus
        } else {
            return character.strengthModifier + character.proficiencyBonus
        }
    }
    
    var damageBonus: Int {
        if weapon.weaponType == .simpleRanged || weapon.weaponType == .martialRanged {
            return character.dexterityModifier
        } else {
            return character.strengthModifier
        }
    }
    
    
    var body: some View {
        HStack(spacing: 12) {
            // Icône d'arme
            Image(systemName: "figure.fencing")
                .font(.title3)
                .foregroundColor(.red)
                .frame(width: 30)
            
            // Nom et informations de l'arme
            VStack(alignment: .leading, spacing: 4) {
                Text(weapon.name)
                    .font(.body)
                    .fontWeight(isEquipped ? .semibold : .regular)
                
                HStack(spacing: 8) {
                    // Type d'arme
                    if let weaponType = weapon.weaponType {
                        Text(weaponType.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Dégâts et type de dégâts
                    if let damageDice = weapon.damageDice, let damageType = weapon.damageType {
                        HStack(spacing: 4) {
                            Text("\(damageDice)+\(damageBonus) \(damageType.rawValue)")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                }
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(attackBonus >= 0 ? "+\(attackBonus)" : "\(attackBonus)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text("Attaque")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isEquipped ? Color.red.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}
