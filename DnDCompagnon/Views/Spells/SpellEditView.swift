//
//  SpellEditView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI
import SwiftData

struct SpellEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var spell: Spell

    @State private var viewModel: SpellEditViewModel

    init(spell: Spell) {
        self.spell = spell
        _viewModel = State(initialValue: SpellEditViewModel(spell: spell))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Nom du sort
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom du sort")
                            .font(.headline)
                        TextField("Nom", text: $spell.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // MARK: - Niveau et école
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Niveau")
                                .font(.headline)
                            Picker("Niveau", selection: $spell.niveau) {
                                Text("Tour de magie").tag(0)
                                ForEach(1...9, id: \.self) { n in
                                    Text("Niveau \(n)").tag(n)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("École")
                                .font(.headline)
                            Picker("École", selection: $spell.ecole) {
                                ForEach(SpellEditViewModel.ecolesDeMagie, id: \.self) { ecole in
                                    Text(ecole).tag(ecole)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    
                    // MARK: - Caractéristiques (bloc principal)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caractéristiques")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Portée")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Portée", text: $spell.portee)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            HStack {
                                Text("Incantation")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Temps d'incantation", text: $spell.dureeIncantation)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            HStack {
                                Text("Durée")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Durée", text: $spell.duree)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            Toggle("Concentration", isOn: $spell.concentration)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // MARK: - Composantes (bloc)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Composantes")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            Toggle("Verbal (V)", isOn: $spell.componentV)
                            Toggle("Somatique (S)", isOn: $spell.componentS)
                            Toggle("Matériel (M)", isOn: $spell.componentM)
                            
                            if spell.componentM {
                                TextField("Spécifiez le matériel", text: $spell.materialDescription)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // MARK: - Propriétés offensives (bloc)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Propriétés offensives")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            Toggle("Sort offensif", isOn: $spell.isOffensive)
                            
                            if spell.isOffensive {
                                HStack {
                                    Text("Dégâts")
                                        .frame(width: 120, alignment: .leading)
                                    TextField("ex: 1d8, 2d6+3", text: Binding(
                                        get: { spell.damageAmount ?? "" },
                                        set: { spell.damageAmount = $0.isEmpty ? nil : $0 }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                }
                                
                                HStack {
                                    Text("Dégâts alt.")
                                        .frame(width: 120, alignment: .leading)
                                    TextField("ex: moitié", text: Binding(
                                        get: { spell.alternateDamageAmount ?? "" },
                                        set: { spell.alternateDamageAmount = $0.isEmpty ? nil : $0 }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                }
                                
                                Divider()
                                
                                Toggle("Jet de sauvegarde", isOn: $spell.requiresSavingThrow)
                                
                                if spell.requiresSavingThrow {
                                    Picker("Statistique", selection: Binding(
                                        get: { spell.savingThrowStat ?? "Dextérité" },
                                        set: { spell.savingThrowStat = $0 }
                                    )) {
                                        ForEach(Spell.savingThrowStats, id: \.self) { stat in
                                            Text(stat).tag(stat)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // MARK: - Classes (sélection horizontale)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Classes")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Spell.classesDnD, id: \.self) { classe in
                                    Button(action: {
                                        viewModel.toggleClass(classe)
                                    }) {
                                        Text(classe)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(viewModel.editingClasses.contains(classe) ? Color.accentColor : Color.gray.opacity(0.2))
                                            .foregroundColor(viewModel.editingClasses.contains(classe) ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        TextEditor(text: $spell.descriptionSort)
                            .frame(minHeight: 120)
                            .padding(4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Éditer le sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}
