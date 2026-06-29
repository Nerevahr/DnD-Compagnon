//
//  EmptyOffensiveCantripsView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 17/06/2026.
//

import SwiftUI

struct EmptyOffensiveCantripsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.purple.opacity(0.3))
            Text("Aucun tour de magie offensif")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Préparez des tours de magie offensifs")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}
