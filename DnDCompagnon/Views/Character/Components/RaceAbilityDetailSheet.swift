//
//  RaceAbilityDetailSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


import SwiftUI

struct RaceAbilityDetailSheet: View {
    let ability: RaceAbility
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    
                    Text(ability.name)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Divider()
                
                Text(ability.description)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Aptitude Raciale")
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