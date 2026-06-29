//
//  CombatPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 14/06/2026.
//

import SwiftUI
import SwiftData

/// Page affichant les options de combat du personnage
struct CombatPage: View {
    @Bindable var character: Character
    
    // Armes dans l'inventaire
    var weapons: [Item] {
        character.inventory.filter { $0.type == .arme }
    }
    
    // Tours de magie offensifs préparés (extraits des PreparedSpell)
    var offensiveCantrips: [PreparedSpell] {
        character.preparedSpells.filter {
            $0.baseSpell?.niveau == 0 && $0.baseSpell?.isOffensive == true
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Combat")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Section Armes
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "figure.fencing")
                            .foregroundColor(.red)
                        Text("Armes")
                            .font(.headline)
                    }
                    
                    if weapons.isEmpty {
                        EmptyWeaponsView()
                    } else {
                        ForEach(weapons) { weapon in
                            WeaponRow(character: character, weapon: weapon)
                        }
                    }
                }
                .padding()
                .background(Color.red.opacity(0.05))
                .cornerRadius(10)
                
                // Section Tours de magie offensifs
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.purple)
                        Text("Tours de magie offensifs")
                            .font(.headline)
                    }
                    
                    if offensiveCantrips.isEmpty {
                        EmptyOffensiveCantripsView()
                    } else {
                        ForEach(offensiveCantrips, id: \.persistentModelID) { preparedCantrip in
                            if let spell = preparedCantrip.baseSpell {
                                OffensiveCantripRow(character: character, spell: spell, preparedSpell: preparedCantrip)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.05))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview("Magicien avec armes") {
    let character = MockData.wizardWithEquippedWeapon()
    return CombatPage(character: character)
}

#Preview("Guerrier") {
    CombatPage(character: MockData.fighter)
}

#Preview("Sans armes ni sorts") {
    let emptyCharacter = Character(
        name: "Aventurier débutant",
        level: 1,
        race: "Halfelin",
        origin: "Criminel"
    )
    return CombatPage(character: emptyCharacter)
}
