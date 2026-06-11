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
            proficientSkills: Array(proficientSkills)
        )
        onSave(newCharacter)
    }
}

struct StatRow: View {
    let name: String
    @Binding var value: Int
    
    var modifier: Int {
        (value - 10) / 2
    }
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .frame(width: 90, alignment: .leading)
            
            // Bouton - pour décrémenter
            Button(action: {
                if value > 1 {
                    value -= 1
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(value > 1 ? .blue : .gray)
            }
            .buttonStyle(.plain)
            
            // Affichage de la valeur
            Text("\(value)")
                .font(.headline)
                .frame(width: 30)
            
            // Bouton + pour incrémenter
            Button(action: {
                if value < 20 {
                    value += 1
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(value < 20 ? .blue : .gray)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Modificateur
            Text(modifierString)
                .foregroundColor(modifier >= 0 ? .green : .red)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}
