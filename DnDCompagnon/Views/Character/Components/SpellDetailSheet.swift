//
//  SpellDetailSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  SpellDetailSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Feuille détaillée d'un sort
struct SpellDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let spell: Spell
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Niveau et école
                    HStack {
                        Text(spell.niveauLabel)
                            .font(.headline)
                            .foregroundColor(.purple)
                        Spacer()
                        Text(spell.ecole)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    // Infos rapides
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Temps d'incantation", value: spell.dureeIncantation)
                        InfoRow(label: "Portée", value: spell.portee)
                        InfoRow(label: "Composantes", value: spell.formattedComponents)
                        if spell.componentM && !spell.materialDescription.isEmpty {
                            InfoRow(label: "Matériel", value: spell.materialDescription)
                        }
                        InfoRow(label: "Durée", value: spell.duree)
                        if spell.concentration {
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.orange)
                                Text("Concentration")
                                    .foregroundColor(.orange)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Description
                    if !spell.descriptionSort.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(spell.descriptionSort)
                                .font(.body)
                        }
                    }
                    
                    // Classes
                    if !spell.classes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Classes")
                                .font(.headline)
                            Text(spell.classesLabel)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(spell.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}