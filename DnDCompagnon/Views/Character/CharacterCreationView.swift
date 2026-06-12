//
//  CharacterCreationView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterCreationView: View {
    @Environment(\.dismiss) private var dismiss
    
    let availableClasses: [DnDClass]
    let onSave: (Character) -> Void
    
    @State private var name: String = ""
    @State private var selectedClass: DnDClass?
    @State private var race: String = ""
    @State private var origin: String = ""
    @State private var level: Int = 1
    
    // Statistiques
    @State private var strength: Int = 10
    @State private var dexterity: Int = 10
    @State private var constitution: Int = 10
    @State private var intelligence: Int = 10
    @State private var wisdom: Int = 10
    @State private var charisma: Int = 10
    
    // Compétences maîtrisées
    @State private var proficientSkills: Set<String> = []
    
    // Points de vie
    @State private var maxHitPoints: Int = 8
    
    private var defaultMaxHP: Int {
        let constitutionMod = (constitution - 10) / 2
        return 8 + constitutionMod
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Informations générales") {
                    TextField("Nom du personnage", text: $name)
                    
                    Picker("Classe", selection: $selectedClass) {
                        Text("Aucune classe").tag(nil as DnDClass?)
                        ForEach(availableClasses) { dndClass in
                            Text(dndClass.name).tag(dndClass as DnDClass?)
                        }
                    }
                    
                    TextField("Race", text: $race)
                    TextField("Origine", text: $origin)
                    Stepper("Niveau: \(level)", value: $level, in: 1...20)
                }
                
                Section {
                    Stepper("Points de vie max: \(maxHitPoints)", value: $maxHitPoints, in: 1...999)
                    Text("Valeur suggérée: \(defaultMaxHP)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Points de vie")
                } footer: {
                    Text("Par défaut: 8 + modificateur de Constitution (\(defaultMaxHP))")
                        .font(.caption)
                }
                
                Section {
                    StatRow(name: "Force", value: $strength)
                    StatRow(name: "Dextérité", value: $dexterity)
                    StatRow(name: "Constitution", value: $constitution)
                    StatRow(name: "Intelligence", value: $intelligence)
                    StatRow(name: "Sagesse", value: $wisdom)
                    StatRow(name: "Charisme", value: $charisma)
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
            .navigationTitle("Nouveau personnage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Créer") {
                        createCharacter()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func createCharacter() {
        let newCharacter = Character(
            timestamp: Date(),
            name: name,
            level: level,
            dndClass: selectedClass,
            race: race,
            origin: origin,
            strength: strength,
            dexterity: dexterity,
            constitution: constitution,
            intelligence: intelligence,
            wisdom: wisdom,
            charisma: charisma,
            proficientSkills: Array(proficientSkills),
            maximumHitPoints: maxHitPoints
        )
        onSave(newCharacter)
    }
}
