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

    @Bindable var character: Character

    @Query(sort: \Race.name) private var races: [Race]
    @Query(sort: \Background.name) private var backgrounds: [Background]
    @Query(sort: \DnDClass.name) private var classes: [DnDClass]

    @State private var proficientSkills: Set<String> = []

    var body: some View {
        NavigationView {
            Form {
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

                    Picker("Origine", selection: $character.origin) {
                        Text("Aucune origine").tag(nil as Background?)
                        ForEach(backgrounds) { background in
                            Text(background.name).tag(background as Background?)
                        }
                    }

                    Stepper("Niveau: \(character.level)", value: $character.level, in: 1...20)
                }

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
                } header: {
                    Text("Points de vie")
                } footer: {
                    Text("Ajustez les points de vie actuels et maximum de votre personnage.")
                        .font(.caption)
                }

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

                Section {
                    ForEach(sortedSkills(), id: \.name) { skill in
                        Button {
                            if proficientSkills.contains(skill.name) {
                                proficientSkills.remove(skill.name)
                            } else {
                                proficientSkills.insert(skill.name)
                            }
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
                                if proficientSkills.contains(skill.name) {
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
            .navigationTitle("Éditer le personnage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        character.proficientSkills = Array(proficientSkills)
                        dismiss()
                    }
                    .disabled(character.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                proficientSkills = Set(character.proficientSkills)
            }
        }
    }

    private func sortedSkills() -> [DnDSkill] {
        let statOrder = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
        return Character.allSkills.sorted { skill1, skill2 in
            let index1 = statOrder.firstIndex(of: skill1.baseStat) ?? 999
            let index2 = statOrder.firstIndex(of: skill2.baseStat) ?? 999
            if index1 == index2 { return skill1.name < skill2.name }
            return index1 < index2
        }
    }
}
