//
//  EmptySpellsView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 13/06/2026.
//


import SwiftUI

/// Vue affichée quand aucun sort n'est préparé
struct EmptySpellsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.purple.opacity(0.3))
            Text("Aucun sort préparé")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Appuyez sur + pour ajouter des sorts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}