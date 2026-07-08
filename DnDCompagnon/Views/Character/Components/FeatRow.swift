//
//  FeatRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI

struct FeatRow: View {
    let feat: Feat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Badge coloré du type
                Circle()
                    .fill(feat.type.color)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(feat.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(feat.type.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Description tronquée
            if !feat.featDescription.isEmpty {
                Text(feat.featDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.leading, 20)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FeatRow(feat: Feat(
        name: "Alerte",
        type: .general,
        featDescription: "Vous gagnez +5 à l'initiative et aux jets de sauvegarde contre les effets de surprise."
    ))
}
