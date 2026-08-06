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
    var character: Character? = nil

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

    // Origine du sort préparé
    @State private var source: PreparedSpellSource
    @State private var selectedSourceFeatID: UUID?
    @State private var selectedSourceAbilityName: String?

    /// Dons candidats pour l'origine "Don" : dons ajoutés + don d'origine, dédupliqués
    private var candidateSourceFeats: [Feat] {
        guard let character = character else { return [] }
        var feats = character.feats
        if let originFeat = character.origin?.originFeat, !feats.contains(where: { $0.id == originFeat.id }) {
            feats.append(originFeat)
        }
        return feats.sorted { $0.name < $1.name }
    }

    /// Aptitudes candidates pour l'origine "Aptitude", dédupliquées par nom
    private var candidateSourceAbilities: [ClassAbility] {
        guard let abilities = character?.dndClass?.abilities else { return [] }
        var seenNames = Set<String>()
        return abilities
            .filter { seenNames.insert($0.name).inserted }
            .sorted { $0.name < $1.name }
    }

    init(preparedSpell: PreparedSpell, character: Character? = nil) {
        self.preparedSpell = preparedSpell
        self.character = character

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

        // Initialisation de l'origine
        _source = State(initialValue: preparedSpell.source)
        _selectedSourceFeatID = State(initialValue: preparedSpell.sourceFeat?.id)
        _selectedSourceAbilityName = State(initialValue: preparedSpell.sourceAbilityName)
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

                // Section Origine
                Section {
                    Picker("Origine", selection: $source) {
                        ForEach(PreparedSpellSource.allCases, id: \.self) { source in
                            Text(source.displayName).tag(source)
                        }
                    }

                    if source == .don {
                        Picker("Don", selection: $selectedSourceFeatID) {
                            Text("Aucun").tag(nil as UUID?)
                            ForEach(candidateSourceFeats) { feat in
                                Text(feat.name).tag(feat.id as UUID?)
                            }
                        }
                    }

                    if source == .aptitude {
                        Picker("Aptitude", selection: $selectedSourceAbilityName) {
                            Text("Aucune").tag(nil as String?)
                            ForEach(candidateSourceAbilities) { ability in
                                Text(ability.name).tag(ability.name as String?)
                            }
                        }
                    }
                } header: {
                    Text("Origine")
                } footer: {
                    Text("Indique si ce sort vient de la progression normale de la classe, d'un don, ou d'une aptitude de classe.")
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
        // Sauvegarde de l'origine
        preparedSpell.source = source
        switch source {
        case .classe:
            preparedSpell.sourceFeat = nil
            preparedSpell.sourceAbilityName = nil
        case .don:
            preparedSpell.sourceFeat = candidateSourceFeats.first { $0.id == selectedSourceFeatID }
            preparedSpell.sourceAbilityName = nil
        case .aptitude:
            preparedSpell.sourceFeat = nil
            preparedSpell.sourceAbilityName = selectedSourceAbilityName
        }

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