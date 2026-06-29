//
//  PreparedSpellEditView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 19/06/2026.
//


//
//  PreparedSpellEditView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 19/06/2026.
//

import SwiftUI
import SwiftData

/// Vue d'édition pour personnaliser un sort préparé
struct PreparedSpellEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var preparedSpell: PreparedSpell
    
    @State private var customDamageAmount: String
    @State private var customAlternateDamageAmount: String
    @State private var customSavingThrowStat: String
    @State private var customDescription: String
    @State private var notes: String
    
    // Toggle pour activer/désactiver les personnalisations
    @State private var useCustomDamage: Bool
    @State private var useCustomAlternateDamage: Bool
    @State private var useCustomSavingThrow: Bool
    @State private var useCustomDescription: Bool
    
    init(preparedSpell: PreparedSpell) {
        self.preparedSpell = preparedSpell
        
        // Initialisation des états
        _customDamageAmount = State(initialValue: preparedSpell.customDamageAmount ?? preparedSpell.baseSpell?.damageAmount ?? "")
        _customAlternateDamageAmount = State(initialValue: preparedSpell.customAlternateDamageAmount ?? preparedSpell.baseSpell?.alternateDamageAmount ?? "")
        _customSavingThrowStat = State(initialValue: preparedSpell.customSavingThrowStat ?? preparedSpell.baseSpell?.savingThrowStat ?? "")
        _customDescription = State(initialValue: preparedSpell.customDescription ?? preparedSpell.baseSpell?.descriptionSort ?? "")
        _notes = State(initialValue: preparedSpell.notes ?? "")
        
        // Initialisation des toggles
        _useCustomDamage = State(initialValue: preparedSpell.customDamageAmount != nil)
        _useCustomAlternateDamage = State(initialValue: preparedSpell.customAlternateDamageAmount != nil)
        _useCustomSavingThrow = State(initialValue: preparedSpell.customSavingThrowStat != nil)
        _useCustomDescription = State(initialValue: preparedSpell.customDescription != nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Section Info du sort de base
                Section {
                    if let spell = preparedSpell.baseSpell {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(spell.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(spell.niveauLabel)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text(spell.ecole)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if spell.isOffensive {
                                Label("Sort offensif", systemImage: "flame.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Sort de base")
                }
                
                // Section Dégâts
                if preparedSpell.baseSpell?.isOffensive == true {
                    Section {
                        Toggle("Personnaliser les dégâts", isOn: $useCustomDamage)
                        
                        if useCustomDamage {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Valeur par défaut : \(preparedSpell.baseSpell?.damageAmount ?? "N/A")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                TextField("Dégâts personnalisés", text: $customDamageAmount)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    } header: {
                        Text("Dégâts")
                    } footer: {
                        Text("Format : 1d8, 2d6+3, etc.")
                    }
                    
                    // Section Dégâts alternatifs
                    if preparedSpell.baseSpell?.alternateDamageAmount != nil || useCustomAlternateDamage {
                        Section {
                            Toggle("Personnaliser les dégâts alternatifs", isOn: $useCustomAlternateDamage)
                            
                            if useCustomAlternateDamage {
                                VStack(alignment: .leading, spacing: 4) {
                                    if let altDamage = preparedSpell.baseSpell?.alternateDamageAmount {
                                        Text("Valeur par défaut : \(altDamage)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    TextField("Dégâts alternatifs", text: $customAlternateDamageAmount)
                                        .textFieldStyle(.roundedBorder)
                                }
                            }
                        } header: {
                            Text("Dégâts alternatifs")
                        } footer: {
                            Text("Utilisé en cas de succès partiel au jet de sauvegarde")
                        }
                    }
                }
                
                // Section Jet de Sauvegarde
                if preparedSpell.baseSpell?.requiresSavingThrow == true {
                    Section {
                        Toggle("Personnaliser le jet de sauvegarde", isOn: $useCustomSavingThrow)
                        
                        if useCustomSavingThrow {
                            VStack(alignment: .leading, spacing: 4) {
                                if let savingStat = preparedSpell.baseSpell?.savingThrowStat {
                                    Text("Valeur par défaut : \(savingStat)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Picker("Caractéristique", selection: $customSavingThrowStat) {
                                    ForEach(Spell.savingThrowStats, id: \.self) { stat in
                                        Text(stat).tag(stat)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                    } header: {
                        Text("Jet de sauvegarde")
                    }
                }
                
                // Section Description
                Section {
                    Toggle("Personnaliser la description", isOn: $useCustomDescription)
                    
                    if useCustomDescription {
                        VStack(alignment: .leading, spacing: 4) {
                            if let baseDesc = preparedSpell.baseSpell?.descriptionSort, !baseDesc.isEmpty {
                                Text("Description par défaut :")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(baseDesc)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            
                            TextEditor(text: $customDescription)
                                .frame(minHeight: 100)
                                .padding(4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                } header: {
                    Text("Description")
                }
                
                // Section Notes personnelles
                Section {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                } header: {
                    Text("Notes personnelles")
                } footer: {
                    Text("Ajoutez vos propres notes ou rappels pour ce sort")
                }
                
                // Section Réinitialisation
                if preparedSpell.hasCustomizations {
                    Section {
                        Button(role: .destructive) {
                            resetAllCustomizations()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Réinitialiser toutes les personnalisations")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Personnaliser le sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        saveChanges()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveChanges() {
        // Sauvegarde des dégâts
        preparedSpell.customDamageAmount = useCustomDamage ? customDamageAmount : nil
        
        // Sauvegarde des dégâts alternatifs
        preparedSpell.customAlternateDamageAmount = useCustomAlternateDamage ? customAlternateDamageAmount : nil
        
        // Sauvegarde du jet de sauvegarde
        preparedSpell.customSavingThrowStat = useCustomSavingThrow ? customSavingThrowStat : nil
        
        // Sauvegarde de la description
        preparedSpell.customDescription = useCustomDescription ? customDescription : nil
        
        // Sauvegarde des notes
        preparedSpell.notes = notes.isEmpty ? nil : notes
    }
    
    private func resetAllCustomizations() {
        withAnimation {
            // Réinitialiser tous les toggles
            useCustomDamage = false
            useCustomAlternateDamage = false
            useCustomSavingThrow = false
            useCustomDescription = false
            
            // Réinitialiser les valeurs
            customDamageAmount = preparedSpell.baseSpell?.damageAmount ?? ""
            customAlternateDamageAmount = preparedSpell.baseSpell?.alternateDamageAmount ?? ""
            customSavingThrowStat = preparedSpell.baseSpell?.savingThrowStat ?? ""
            customDescription = preparedSpell.baseSpell?.descriptionSort ?? ""
            notes = ""
            
            // Appliquer les changements
            preparedSpell.customDamageAmount = nil
            preparedSpell.customAlternateDamageAmount = nil
            preparedSpell.customSavingThrowStat = nil
            preparedSpell.customDescription = nil
            preparedSpell.notes = nil
        }
    }
}