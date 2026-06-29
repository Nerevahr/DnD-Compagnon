//
//  EmptyWeaponsView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 17/06/2026.
//

import SwiftUI

struct EmptyWeaponsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.fencing")
                .font(.system(size: 40))
                .foregroundColor(.red.opacity(0.3))
            Text("Aucune arme")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Ajoutez des armes à votre inventaire")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}
