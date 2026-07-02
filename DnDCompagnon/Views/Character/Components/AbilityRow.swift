//
//  AbilityRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


//
//  AbilityRow.swift
//  DnDCompagnon
//

import SwiftUI

struct AbilityRow: View {
    let ability: ClassAbility
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ability.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let description = ability.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        AbilityRow(ability: ClassAbility(
            level: 1,
            name: "Style de combat",
            description: "Vous adoptez un style de combat particulier comme votre spécialité."
        ))
        
        AbilityRow(ability: ClassAbility(
            level: 2,
            name: "Second souffle"
        ))
    }
    .padding()
}