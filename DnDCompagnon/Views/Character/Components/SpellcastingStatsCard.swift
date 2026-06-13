//
//  SpellcastingStatsCard.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/06/2026.
//


import SwiftUI

/// Carte affichant les statistiques d'incantation
struct SpellcastingStatsCard: View {
    let character: Character
    let spellcastingAbility: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Caractéristique d'incantation")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(spellcastingAbility)
                    .font(.headline)
                    .foregroundColor(.purple)
            }
            
            Divider()
            
            HStack(spacing: 20) {
                if let spellDC = character.spellSaveDC {
                    VStack(spacing: 4) {
                        Text("DD des sorts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(spellDC)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Divider()
                    .frame(height: 40)
                
                if let attackBonus = character.spellAttackBonusFormatted {
                    VStack(spacing: 4) {
                        Text("Bonus d'attaque")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(attackBonus)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
    }
}