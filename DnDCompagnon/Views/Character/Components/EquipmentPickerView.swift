//
//  EquipmentPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

/// Vue pour équiper un item depuis l'inventaire
struct EquipmentPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var character: Character
    let equipmentType: ItemType
    let title: String
    
    // Items du type demandé dans l'inventaire
    private var availableItems: [Item] {
        character.inventory.filter { $0.type == equipmentType }
    }
    
    // Item actuellement équipé
    private var currentEquippedItem: Item? {
        switch equipmentType {
        case .armure:
            return character.equippedArmor
        case .arme:
            return character.equippedWeapon
        case .bouclier:
            return character.equippedShield
        default:
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Option pour déséquiper
                if currentEquippedItem != nil {
                    Button(role: .destructive) {
                        unequipItem()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Déséquiper")
                        }
                    }
                }
                
                // Items disponibles dans l'inventaire
                Section {
                    if availableItems.isEmpty {
                        ContentUnavailableView(
                            "Aucun \(equipmentType.rawValue.lowercased()) dans l'inventaire",
                            systemImage: getSystemImage(),
                            description: Text("Ajoutez des objets à votre inventaire")
                        )
                    } else {
                        ForEach(availableItems) { item in
                            Button {
                                equipItem(item)
                                dismiss()
                            } label: {
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if item == currentEquippedItem {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("Dans votre inventaire")
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func equipItem(_ item: Item) {
        switch equipmentType {
        case .armure:
            character.equippedArmor = item
        case .arme:
            character.equippedWeapon = item
        case .bouclier:
            character.equippedShield = item
        default:
            break
        }
    }
    
    private func unequipItem() {
        switch equipmentType {
        case .armure:
            character.equippedArmor = nil
        case .arme:
            character.equippedWeapon = nil
        case .bouclier:
            character.equippedShield = nil
        default:
            break
        }
    }
    
    private func getSystemImage() -> String {
        switch equipmentType {
        case .armure:
            return "shield.lefthalf.filled"
        case .arme:
            return "sword.fill"
        case .bouclier:
            return "shield.fill"
        default:
            return "questionmark"
        }
    }
}
