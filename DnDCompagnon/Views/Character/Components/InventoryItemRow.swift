//
//  InventoryItemRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

/// Vue pour afficher un item dans l'inventaire
struct InventoryItemRow: View {
    @Bindable var character: Character
    let item: Item
    let onRemove: () -> Void
    
    // Vérifier si l'item est équipé
    private var isEquipped: Bool {
        item == character.equippedArmor ||
        item == character.equippedWeapon ||
        item == character.equippedShield
    }
    
    // Vérifier si l'item peut être équipé
    private var canBeEquipped: Bool {
        item.type == .armure || item.type == .arme || item.type == .bouclier
    }
    
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
                
                HStack(spacing: 4) {
                    Text(item.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Afficher les détails de l'armure
                    if item.type == .armure, let category = item.armorCategory {
                        if category == .vetement {
                            Text("• Vêtement")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if let baseCA = item.baseArmorClass {
                            Text("• \(category.rawValue) (CA \(baseCA))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if isEquipped {
                        Text("• Équipé")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            Spacer()
            
            // Bouton équiper/déséquiper si applicable
            if canBeEquipped {
                Button {
                    toggleEquip()
                } label: {
                    Image(systemName: isEquipped ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isEquipped ? .blue : .gray)
                }
                .buttonStyle(.plain)
            }
            
            Button(role: .destructive) {
                onRemove()
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
    }
    
    private func toggleEquip() {
        switch item.type {
        case .armure:
            if character.equippedArmor == item {
                character.equippedArmor = nil
            } else {
                character.equippedArmor = item
            }
        case .arme:
            if character.equippedWeapon == item {
                character.equippedWeapon = nil
            } else {
                character.equippedWeapon = item
            }
        case .bouclier:
            if character.equippedShield == item {
                character.equippedShield = nil
            } else {
                character.equippedShield = item
            }
        default:
            break
        }
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
