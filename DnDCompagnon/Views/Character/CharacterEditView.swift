//
//  CharacterEditView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


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
    let availableClasses: [DnDClass]
    
    @State private var proficientSkills: Set<String> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Informations générales") {
                    TextField("Nom du personnage", text: $character.name)
                    
                    Picker("Classe", selection: $character.dndClass) {
                        Text("Aucune classe").tag(nil as DnDClass?)
                        ForEach(availableClasses) { dndClass in
                            Text(dndClass.name).tag(dndClass as DnDClass?)
                        }
                    }
                    
                    TextField("Race", text: $character.race)
                    
                    TextField("Origine", text: $character.origin)
                    
                    Stepper("Niveau: \(character.level)", value: $character.level, in: 1...20)
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
                    ForEach(Character.allSkills, id: \.name) { skill in
                        Toggle(isOn: Binding(
                            get: { proficientSkills.contains(skill.name) },
                            set: { isOn in
                                if isOn {
                                    proficientSkills.insert(skill.name)
                                } else {
                                    proficientSkills.remove(skill.name)
                                }
                            }
                        )) {
                            VStack(alignment: .leading) {
                                Text(skill.name)
                                Text(skill.baseStat)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
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
                    Button("Annuler") {
                        dismiss()
                    }
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
}