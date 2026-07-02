//
//  RaceAbilityRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


import SwiftUI

struct RaceAbilityRow: View {
    let ability: RaceAbility
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    
                    Text(ability.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Text(ability.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
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