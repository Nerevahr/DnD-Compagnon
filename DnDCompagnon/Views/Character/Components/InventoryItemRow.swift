//
//  InventoryItemRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

/// Vue pour afficher un item dans l'inventaire
struct InventoryItemRow: View {
    let item: Item
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icône selon le type
            Image(systemName: iconForItemType(item.type))
                .font(.title3)
                .foregroundColor(colorForItemType(item.type))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(role: .destructive) {
                onRemove()
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
    }
    
    private func iconForItemType(_ type: ItemType) -> String {
        switch type {
        case .armure:
            return "shield.lefthalf.filled"
        case .arme:
            return "sword.fill"
        case .bouclier:
            return "shield.fill"
        case .consommable:
            return "flask.fill"
        case .tresor:
            return "diamond.fill"
        case .outilArtisan:
            return "hammer.fill"
        default:
            return "cube.box.fill"
        }
    }
    
    private func colorForItemType(_ type: ItemType) -> Color {
        switch type {
        case .armure:
            return .blue
        case .arme:
            return .red
        case .bouclier:
            return .green
        case .consommable:
            return .purple
        case .tresor:
            return .yellow
        default:
            return .gray
        }
    }
}