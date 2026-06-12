//
//  EquipmentSlot.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

/// Vue pour afficher un emplacement d'équipement
struct EquipmentSlot: View {
    let icon: String
    let label: String
    let item: Item?
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Icône
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            // Label
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            // Item équipé ou placeholder
            if let item = item {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.medium)
            } else {
                Text("Aucun(e)")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Spacer()
            
            // Bouton pour changer
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
    }
}