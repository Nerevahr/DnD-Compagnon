//
//  InventoryPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  InventoryPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Page affichant l'inventaire du personnage
struct InventoryPage: View {
    let character: Character
    
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
                    Text("0")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("po")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                // Placeholder pour l'inventaire
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
            }
            .padding()
        }
    }
}