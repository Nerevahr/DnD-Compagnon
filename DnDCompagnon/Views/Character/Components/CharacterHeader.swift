//
//  CharacterHeader.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// En-tête avec les informations principales du personnage
struct CharacterHeader: View {
    let character: Character
    
    /// Pourcentage de PV restants (0.0 à 1.0)
    private var hpPercentage: Double {
        guard character.maximumHitPoints > 0 else { return 0 }
        return Double(character.currentHitPoints) / Double(character.maximumHitPoints)
    }

    /// Couleur de la barre de PV en fonction du pourcentage
    private var hpColor: Color {
        if hpPercentage >= 0.5 {
            return .green
        } else if hpPercentage >= 0.2 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(character.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                if !character.race.isEmpty {
                    Label(character.race, systemImage: "person.fill")
                        .foregroundColor(.green)
                }
                if !character.origin.isEmpty {
                    Label(character.origin, systemImage: "book.fill")
                        .foregroundColor(.orange)
                }
            }
            .font(.subheadline)
            
            HStack {
                if let dndClass = character.dndClass {
                    Label(dndClass.name, systemImage: "shield.fill")
                        .foregroundColor(.blue)
                }
                // placeholder for subclass
            }
            .font(.headline)
            
            Label("Niveau \(character.level)", systemImage: "star.fill")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Barre de PV
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("Points de vie", systemImage: "heart.fill")
                        .font(.subheadline)
                        .foregroundColor(hpColor)
                    Spacer()
                    Text("\(character.currentHitPoints) / \(character.maximumHitPoints)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                ProgressView(value: hpPercentage)
                    .tint(hpColor)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }
}
