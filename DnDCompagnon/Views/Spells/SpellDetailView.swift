//
//  SpellDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

struct SpellDetailView: View {
    @Bindable var spell: Spell
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
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
                
                // Propriétés offensives
                if spell.isOffensive {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("Sort offensif")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        
                        if let damage = spell.damageAmount {
                            InfoRow(label: "Dégâts", value: damage)
                        }
                        
                        if let altDamage = spell.alternateDamageAmount {
                            InfoRow(label: "Dégâts alternatifs", value: altDamage)
                        }
                        
                        if spell.requiresSavingThrow, let stat = spell.savingThrowStat {
                            HStack {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(.blue)
                                Text("Jet de sauvegarde : \(stat)")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Description
                if !spell.descriptionSort.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(.init(spell.descriptionSort))
                            .font(.body)
                    }
                }
                
                // Classes
                if !spell.classes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Classes")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(spell.classes, id: \.self) { classe in
                                    Text(classe)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.accentColor.opacity(0.2))
                                        .foregroundColor(.primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Modifier") {
                    isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            SpellEditView(spell: spell)
        }
    }
}

#Preview {
    SpellDetailView(spell: MockData.shieldSpell)
}
