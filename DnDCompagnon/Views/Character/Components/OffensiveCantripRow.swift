//
//  OffensiveCantripRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 17/06/2026.
//

import SwiftUI

struct OffensiveCantripRow: View {
    let character: Character
    let spell: Spell
    let preparedSpell: PreparedSpell?  // ✅ Ajout du PreparedSpell optionnel
    
    // Initializers pour la rétrocompatibilité
    init(character: Character, spell: Spell, preparedSpell: PreparedSpell? = nil) {
        self.character = character
        self.spell = spell
        self.preparedSpell = preparedSpell
    }
    
    // Utilise les valeurs personnalisées si disponibles
    private var damageAmount: String? {
        preparedSpell?.damageAmount ?? spell.damageAmount
    }
    
    private var savingThrowStat: String? {
        preparedSpell?.savingThrowStat ?? spell.savingThrowStat
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icône de sort
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            // Informations du sort
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(spell.name)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    // Indicateur de personnalisation
                    if preparedSpell?.hasCustomizations == true {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
                
                HStack(spacing: 8) {
                    // Durée d'incantation (au lieu de l'école)
                    Text(spell.dureeIncantation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Concentration
                    if spell.concentration {
                        Label("C", systemImage: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                    
                    // Portée
                    Text("• \(spell.portee)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Infos offensives (utilise les valeurs personnalisées)
                if let damage = damageAmount {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundColor(preparedSpell?.customDamageAmount != nil ? .purple : .red)
                        Text(damage)
                            .font(.caption)
                            .foregroundColor(preparedSpell?.customDamageAmount != nil ? .purple : .red)
                        
                        // Jet de sauvegarde si applicable
                        if spell.requiresSavingThrow, let stat = savingThrowStat {
                            Text("• JdS \(stat)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Modificateur d'attaque pour le sort
            if let attackBonus = character.spellAttackBonus {
                VStack(spacing: 2) {
                    Text(attackBonus >= 0 ? "+\(attackBonus)" : "\(attackBonus)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    Text("Attaque")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.purple.opacity(0.05))
        .cornerRadius(8)
    }
}
