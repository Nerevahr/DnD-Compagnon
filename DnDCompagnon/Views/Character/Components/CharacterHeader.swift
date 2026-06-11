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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(character.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                if let dndClass = character.dndClass {
                    Label(dndClass.name, systemImage: "shield.fill")
                        .foregroundColor(.blue)
                }
                // placeholder for subclass
            }
            .font(.headline)
            
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
            
            Label("Niveau \(character.level)", systemImage: "star.fill")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }
}
