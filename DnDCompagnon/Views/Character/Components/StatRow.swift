//
//  StatRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  StatRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Ligne pour éditer une caractéristique (avec +/-)
struct StatRow: View {
    let name: String
    @Binding var value: Int
    
    var modifier: Int {
        (value - 10) / 2
    }
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .frame(width: 90, alignment: .leading)
            
            // Bouton - pour décrémenter
            Button(action: {
                if value > 1 {
                    value -= 1
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(value > 1 ? .blue : .gray)
            }
            .buttonStyle(.plain)
            
            // Affichage de la valeur
            Text("\(value)")
                .font(.headline)
                .frame(width: 30)
            
            // Bouton + pour incrémenter
            Button(action: {
                if value < 20 {
                    value += 1
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(value < 20 ? .blue : .gray)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Modificateur
            Text(modifierString)
                .foregroundColor(modifier >= 0 ? .green : .red)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}