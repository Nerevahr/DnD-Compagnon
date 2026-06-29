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
    @Environment(\.modelContext) private var modelContext
    
    let availableClasses: [DnDClass]
    let onSuccess: () -> Void
    
    @State private var name: String = ""
    @State private var selectedClassID: PersistentIdentifier?
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
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    private var defaultMaxHP: Int {
        let constitutionMod = (constitution - 10) / 2
        return 8 + constitutionMod
    }
    
    private var selectedClass: DnDClass? {
        availableClasses.first { $0.id == selectedClassID }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Informations générales") {
                    TextField("Nom du personnage", text: $name)
                    
                    Picker("Classe", selection: $selectedClassID) {
                        Text("Aucune classe").tag(nil as PersistentIdentifier?)
                        ForEach(availableClasses) { dndClass in
                            Text(dndClass.name).tag(dndClass.id as PersistentIdentifier?)
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
            // ✅ Ajout de l'alerte d'erreur
            .alert("Erreur", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createCharacter() {
        do {
            // Le service gère TOUT : création, insertion, sauvegarde
            let _ = try CharacterService.createCharacter(
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
                context: modelContext
            )
            
            onSuccess()
            dismiss()
        } catch CharacterCreationError.invalidName {
            errorMessage = "Le nom du personnage est invalide."
            showErrorAlert = true
        } catch {
            errorMessage = "Une erreur s'est produite lors de la création du personnage."
            showErrorAlert = true
        }
    }
    
    private func sortedSkills() -> [DnDSkill] {
        let statOrder = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
        return Character.allSkills.sorted { skill1, skill2 in
            let index1 = statOrder.firstIndex(of: skill1.baseStat) ?? 999
            let index2 = statOrder.firstIndex(of: skill2.baseStat) ?? 999
            if index1 == index2 {
                return skill1.name < skill2.name
            }
            return index1 < index2
        }
    }
}
