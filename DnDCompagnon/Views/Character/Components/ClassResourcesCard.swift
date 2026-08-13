//
//  ClassResourcesCard.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/08/2026.
//

import SwiftUI

/// Carte affichant les ressources de classe disponibles et utilisées (ex: Canalisation d'énergie divine)
struct ClassResourcesCard: View {
    @Bindable var character: Character

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ressources de classe")
                    .font(.headline)
                    .foregroundColor(.purple)

                Spacer()

                // Bouton pour reset (restaure toutes les ressources)
                Button(action: {
                    withAnimation {
                        character.restoreAllClassResources()
                    }
                }) {
                    Label("reset", systemImage: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                }
            }

            ForEach(character.dndClass?.classResources ?? []) { resource in
                let maxAmount = character.classResourceCount(named: resource.name)

                if maxAmount > 0 {
                    ClassResourceRow(
                        character: character,
                        resourceName: resource.name,
                        maxAmount: maxAmount
                    )
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(10)
    }
}

/// Ligne pour une ressource de classe avec ses utilisations
struct ClassResourceRow: View {
    @Bindable var character: Character
    let resourceName: String
    let maxAmount: Int

    var usedAmount: Int {
        character.usedClassResourceCount(named: resourceName)
    }

    var remainingAmount: Int {
        character.remainingClassResource(named: resourceName)
    }

    var body: some View {
        HStack {
            Text(resourceName)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            // Carrés pour visualiser les utilisations
            HStack(spacing: 4) {
                ForEach(0..<maxAmount, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            toggleUsage(at: index)
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index < usedAmount ? Color.gray.opacity(0.3) : Color.purple)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.purple.opacity(0.7), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Compteur textuel
            Text("\(remainingAmount)/\(maxAmount)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(remainingAmount == 0 ? .red : .secondary)
                .frame(minWidth: 40, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }

    private func toggleUsage(at index: Int) {
        if index < usedAmount {
            // Clic sur une utilisation consommée -> restaurer
            character.restoreClassResource(named: resourceName)
        } else if index == usedAmount && usedAmount < maxAmount {
            // Clic sur la prochaine utilisation disponible -> consommer
            character.useClassResource(named: resourceName)
        }
    }
}
