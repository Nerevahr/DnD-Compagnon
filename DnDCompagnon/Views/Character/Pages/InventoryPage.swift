//
//  InventoryPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

/// Page affichant l'inventaire du personnage
struct InventoryPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allItems: [Item]
    
    @Bindable var character: Character
    
    @State private var showingItemPicker = false
    @State private var showingGoldEditor = false


    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Inventaire")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Or
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("Or")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.2f", character.gold))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("po")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button {
                        showingGoldEditor = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                // Section Équipement (lecture seule)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Équipement")
                        .font(.headline)
                    
                    // Armure
                    EquipmentSlot(
                        icon: "shield.lefthalf.filled",
                        label: "Armure",
                        item: character.equippedArmor,
                        color: .blue
                    )
                    
                    // Bouclier
                    EquipmentSlot(
                        icon: "shield.fill",
                        label: "Bouclier",
                        item: character.equippedShield,
                        color: .green
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // Section Objets de l'inventaire
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Objets")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingItemPicker = true
                        } label: {
                            Label("Ajouter", systemImage: "plus.circle.fill")
                                .font(.subheadline)
                        }
                    }
                    
                    if character.inventory.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "backpack")
                                .font(.system(size: 50))
                                .foregroundColor(.orange.opacity(0.3))
                            Text("Inventaire vide")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Ajoutez des objets à votre inventaire")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                    } else {
                        ForEach(character.inventory) { item in
                            InventoryItemRow(
                                character: character,
                                item: item,
                                onRemove: {
                                    removeFromInventory(item)
                                }
                            )
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $showingItemPicker) {
            ItemPickerView(
                character: character,
                allItems: allItems
            )
        }
        .sheet(isPresented: $showingGoldEditor) {
            GoldEditorView(gold: $character.gold)
        }
    }
    
    private func removeFromInventory(_ item: Item) {
        // Déséquiper l'item s'il est équipé
        if character.equippedArmor == item {
            character.equippedArmor = nil
        }
        if character.equippedWeapon == item {
            character.equippedWeapon = nil
        }
        if character.equippedShield == item {
            character.equippedShield = nil
        }
        
        // Retirer de l'inventaire
        if let index = character.inventory.firstIndex(of: item) {
            character.inventory.remove(at: index)
        }
    }
}

#Preview("Guerrier") {
    InventoryPage(character: MockData.fighter)
}
