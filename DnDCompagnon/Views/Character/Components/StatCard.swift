//
//  StatCard.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


import SwiftUI

/// Carte affichant une caractéristique, son modificateur et son jet de sauvegarde
struct StatCard: View {
    let name: String
    let value: Int
    let modifier: Int
    let savingThrowBonus: Int
    let isProficientInSavingThrow: Bool
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var savingThrowString: String {
        savingThrowBonus >= 0 ? "+\(savingThrowBonus)" : "\(savingThrowBonus)"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Modificateur et valeur en horizontal
            HStack(spacing: 8) {
                // Modificateur en grand (mis en avant)
                Text(modifierString)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(modifier >= 0 ? .green : .red)
                
                // Valeur de la stat en petit (à côté)
                Text("\(value)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Séparateur
            Divider()
                .padding(.horizontal, 8)
            
            // Jet de sauvegarde en bas
            HStack(spacing: 4) {
                if isProficientInSavingThrow {
                    Image(systemName: "checkmark.seal")
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
                
                Text("JdS")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(savingThrowString)
                    .font(.caption)
                    .fontWeight(isProficientInSavingThrow ? .bold : .regular)
                    .foregroundColor(isProficientInSavingThrow ? .blue : .secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}
