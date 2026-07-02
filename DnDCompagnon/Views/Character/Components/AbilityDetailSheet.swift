//
//  AbilityDetailSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//

import SwiftUI

struct AbilityDetailSheet: View {
    let ability: ClassAbility
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text(ability.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Badge de niveau
                    Text("Niv. \(ability.level)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(6)
                }
                
                Divider()
                
                if let description = ability.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Aucune description disponible")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Aptitude de Classe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    AbilityDetailSheet(ability: ClassAbility(
        level: 1,
        name: "Style de combat",
        description: "Vous adoptez un style de combat particulier comme votre spécialité. Choisissez l'une des options suivantes. Vous ne pouvez pas choisir un style de combat deux fois, même si vous obtenez de nouveau la possibilité d'en choisir un."
    ))
}
