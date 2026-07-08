//
//  CharacterEditView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: CharacterEditViewModel
    @Bindable private var character: Character

    @Query(sort: \Race.name) private var races: [Race]
    @Query(sort: \Background.name) private var backgrounds: [Background]
    @Query(sort: \DnDClass.name) private var classes: [DnDClass]

    init(character: Character) {
        _viewModel = State(initialValue: CharacterEditViewModel(character: character))
        _character = Bindable(character)
    }

    var body: some View {
        NavigationView {
            Form {
                generalInfoSection
                hitPointsSection
                abilitiesSection
                skillsSection
            }
            .navigationTitle("Éditer le personnage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        viewModel.save(modelContext: modelContext)
                        dismiss()
                    }
                    .disabled(character.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $viewModel.showLevelUpSheet) {
                LevelUpSheet(character: character, newLevel: character.level + 1)
            }
            .confirmationDialog(
                "Confirmer la descente de niveau",
                isPresented: $viewModel.showLevelDownConfirmation,
                actions: {
                    Button("Descendre", role: .destructive) {
                        viewModel.confirmLevelDown(modelContext: modelContext)
                    }
                    Button("Annuler", role: .cancel) {}
                },
                message: {
                    if let hpLoss = character.hpLevelHistory[character.level] {
                        Text("Vous allez perdre \(hpLoss) PV maximum.")
                    } else {
                        Text("Êtes-vous sûr de vouloir descendre de niveau ?")
                    }
                }
            )
        }
    }
    
    // MARK: - Sub-views
    
    private var generalInfoSection: some View {
        Section("Informations générales") {
            TextField("Nom du personnage", text: $character.name)

            Picker("Classe", selection: $character.dndClass) {
                Text("Aucune classe").tag(nil as DnDClass?)
                ForEach(classes) { dndClass in
                    Text(dndClass.name).tag(dndClass as DnDClass?)
                }
            }

            Picker("Race", selection: $character.race) {
                Text("Aucune race").tag(nil as Race?)
                ForEach(races) { race in
                    Text(race.name).tag(race as Race?)
                }
            }

            Picker("Origine", selection: Binding(
                get: { character.origin },
                set: { character.setOrigin($0) }
            )) {
                Text("Aucune origine").tag(nil as Background?)
                ForEach(backgrounds) { background in
                    Text(background.name).tag(background as Background?)
                }
            }

            HStack {
                Text("Niveau")
                Spacer()
                HStack(spacing: 12) {
                    Button(action: viewModel.requestLevelDown) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .disabled(character.level <= 1)
                    
                    Text("\(character.level)")
                        .font(.headline)
                        .frame(minWidth: 40)
                    
                    Button(action: viewModel.requestLevelUp) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .disabled(character.level >= 20)
                }
            }
        }
    }

    private var hitPointsSection: some View {
        Section {
            Stepper("PV actuels: \(character.currentHitPoints)", value: $character.currentHitPoints, in: 0...character.maximumHitPoints)
            Stepper("PV maximum: \(character.maximumHitPoints)", value: $character.maximumHitPoints, in: 1...999)

            HStack {
                Text("État:")
                Spacer()
                ProgressView(value: Double(character.currentHitPoints), total: Double(character.maximumHitPoints))
                    .tint(.red)
                    .frame(maxWidth: 150)
                Text("\(Int(Double(character.currentHitPoints) / Double(character.maximumHitPoints) * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !character.hpLevelHistory.isEmpty {
                hpHistoryView
            }
        } header: {
            Text("Points de vie")
        } footer: {
            Text("Ajustez les points de vie actuels et maximum de votre personnage.")
                .font(.caption)
        }
    }
    
    private var hpHistoryView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Historique des PV")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ForEach(character.hpLevelHistory.keys.sorted().reversed(), id: \.self) { level in
                if let hpGain = character.hpLevelHistory[level] {
                    HStack {
                        Text("Niveau \(level)")
                            .font(.caption)
                        Spacer()
                        Text("+\(hpGain) PV")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(6)
    }

    private var abilitiesSection: some View {
        Section {
            StatRow(name: "Force", value: $character.strength)
            StatRow(name: "Dextérité", value: $character.dexterity)
            StatRow(name: "Constitution", value: $character.constitution)
            StatRow(name: "Intelligence", value: $character.intelligence)
            StatRow(name: "Sagesse", value: $character.wisdom)
            StatRow(name: "Charisme", value: $character.charisma)
        } header: {
            Text("Caractéristiques")
        } footer: {
            Text("Les modificateurs sont calculés automatiquement : (Stat - 10) / 2")
                .font(.caption)
        }
    }

    private var skillsSection: some View {
        Section {
            ForEach(viewModel.sortedSkills(), id: \.name) { skill in
                Button {
                    viewModel.toggleSkill(skill.name)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .foregroundColor(.primary)
                            Text(skill.baseStat)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if viewModel.proficientSkills.contains(skill.name) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } header: {
            Text("Maîtrise des compétences")
        } footer: {
            Text("Sélectionnez les compétences que votre personnage maîtrise.")
                .font(.caption)
        }
    }
}
