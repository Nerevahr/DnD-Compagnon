//
//  EquipmentPickerView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI
import SwiftData

/// Vue pour sélectionner un équipement à équiper
struct EquipmentPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allItems: [Item]
    
    @Bindable var character: Character
    let equipmentType: ItemType
    let title: String
    
    // Filtrer les items selon le type
    private var filteredItems: [Item] {
        allItems.filter { $0.type == equipmentType }
    }
    
    // Obtenir l'item actuellement équipé
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
                
                // Liste des items disponibles
                Section {
                    if filteredItems.isEmpty {
                        ContentUnavailableView(
                            "Aucun \(equipmentType.rawValue.lowercased())",
                            systemImage: getSystemImage(),
                            description: Text("Ajoutez des items dans la liste des objets")
                        )
                    } else {
                        ForEach(filteredItems) { item in
                            Button {
                                equipItem(item)
                                dismiss()
                            } label: {
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    // Indicateur si c'est l'item actuellement équipé
                                    if item == currentEquippedItem {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text(equipmentType.rawValue + "s disponibles")
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
    
    // MARK: - Actions
    
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