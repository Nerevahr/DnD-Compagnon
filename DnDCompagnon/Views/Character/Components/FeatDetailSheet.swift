//
//  FeatDetailSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI

struct FeatDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let feat: Feat
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // En-tête avec badge
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(feat.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // Badge du type
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(feat.type.color)
                                    .frame(width: 8, height: 8)
                                Text(feat.type.displayName)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(feat.type.color.opacity(0.1))
                            .cornerRadius(6)
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(feat.featDescription)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Don")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FeatDetailSheet(feat: Feat(
        name: "Alerte",
        type: .general,
        featDescription: "Vous gagnez +5 à l'initiative. Les créatures n'obtiennent pas d'avantage aux jets d'attaque contre vous du fait d'être invisibles."
    ))
}
