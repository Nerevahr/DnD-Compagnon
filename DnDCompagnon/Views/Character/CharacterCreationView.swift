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
    let availableRaces: [Race] // Ajouter la liste des races disponibles
    let onSuccess: () -> Void
    
    @State private var name: String = ""
    @State private var selectedClassID: PersistentIdentifier?
    @State private var selectedRaceID: PersistentIdentifier? // Changé de String à ID
    @State private var selectedBackgroundID: PersistentIdentifier?
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
    
    // Bonus d'origine (Background)
    @State private var backgroundBonusMode: BackgroundStatBonusMode = .triplePlusOne
    @State private var backgroundPlusTwoStat: String = ""
    @State private var backgroundPlusOneStat: String = ""
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    @Query(sort: \Background.name) private var backgrounds: [Background]

    private var selectedBackground: Background? {
        backgrounds.first { $0.id == selectedBackgroundID }
    }
    
    private var defaultMaxHP: Int {
        let constitutionMod = (constitution - 10) / 2
        return 8 + constitutionMod
    }
    
    private var selectedClass: DnDClass? {
        availableClasses.first { $0.id == selectedClassID }
    }
    
    private var selectedRace: Race? {
        availableRaces.first { $0.id == selectedRaceID }
    }
    
    /// Vérifie que le choix de bonus d'origine est valide
    private var isBackgroundBonusValid: Bool {
        // Si pas d'origine, c'est valide (pas de bonus à choisir)
        guard selectedBackground != nil, !selectedBackground!.suggestedStats.isEmpty else {
            return true
        }
        
        // Mode triple +1 : toujours valide
        if backgroundBonusMode == .triplePlusOne {
            return true
        }
        
        // Mode double +2/+1 : les deux stats doivent être choisies et différentes
        return !backgroundPlusTwoStat.isEmpty && !backgroundPlusOneStat.isEmpty && backgroundPlusTwoStat != backgroundPlusOneStat
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
                    
                    Picker("Race", selection: $selectedRaceID) {
                        Text("Aucune race").tag(nil as PersistentIdentifier?)
                        ForEach(availableRaces) { race in
                            Text(race.name).tag(race.id as PersistentIdentifier?)
                        }
                    }
                    
                    Picker("Origine", selection: $selectedBackgroundID) {
                        Text("Aucune origine").tag(nil as PersistentIdentifier?)
                        ForEach(backgrounds) { background in
                            Text(background.name).tag(background.id as PersistentIdentifier?)
                        }
                    }
                    .onChange(of: selectedBackgroundID) { oldValue, newValue in
                        // Réinitialiser les bonus d'origine quand on change de background
                        backgroundBonusMode = .triplePlusOne
                        backgroundPlusTwoStat = ""
                        backgroundPlusOneStat = ""
                    }
                    Stepper("Niveau: \(level)", value: $level, in: 1...20)
                }
                
                // Section pour afficher les aptitudes de la race sélectionnée
                if let race = selectedRace, !race.abilities.isEmpty {
                    Section("Aptitudes raciales") {
                        ForEach(race.abilities) { ability in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ability.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(ability.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // Section pour les bonus d'origine (Background)
                if let background = selectedBackground, !background.suggestedStats.isEmpty {
                    Section("Bonus d'origine") {
                        Picker("Mode de répartition", selection: $backgroundBonusMode) {
                            ForEach(BackgroundStatBonusMode.allCases, id: \.self) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        
                        if backgroundBonusMode == .triplePlusOne {
                            Text("+1 en \(background.suggestedStats.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            VStack(spacing: 16) {
                                Picker("Stat +2", selection: $backgroundPlusTwoStat) {
                                    Text("Sélectionner...").tag("")
                                    ForEach(background.suggestedStats.filter { $0 != backgroundPlusOneStat }, id: \.self) { stat in
                                        Text(stat).tag(stat)
                                    }
                                }
                                
                                Picker("Stat +1", selection: $backgroundPlusOneStat) {
                                    Text("Sélectionner...").tag("")
                                    ForEach(background.suggestedStats.filter { $0 != backgroundPlusTwoStat }, id: \.self) { stat in
                                        Text(stat).tag(stat)
                                    }
                                }
                            }
                        }
                    }
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
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !isBackgroundBonusValid)
                }
            }
            .alert("Erreur", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createCharacter() {
        do {
            // Calculer les scores finaux avec les bonus d'origine
            let (finalStrength, finalDexterity, finalConstitution, finalIntelligence, finalWisdom, finalCharisma) = calculateFinalStats()
            
            // Le service gère TOUT : création, insertion, sauvegarde
            let character = try CharacterService.createCharacter(
                name: name,
                level: level,
                dndClass: selectedClass,
                race: selectedRace, // Maintenant c'est un objet Race?
                background: selectedBackground,
                strength: finalStrength,
                dexterity: finalDexterity,
                constitution: finalConstitution,
                intelligence: finalIntelligence,
                wisdom: finalWisdom,
                charisma: finalCharisma,
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
    
    /// Calcule les scores finaux avec les bonus d'origine
    private func calculateFinalStats() -> (Int, Int, Int, Int, Int, Int) {
        var stats: [String: Int] = [
            "Force": strength,
            "Dextérité": dexterity,
            "Constitution": constitution,
            "Intelligence": intelligence,
            "Sagesse": wisdom,
            "Charisme": charisma
        ]
        
        // Appliquer les bonus d'origine si disponible
        if let background = selectedBackground, !background.suggestedStats.isEmpty {
            if backgroundBonusMode == .triplePlusOne {
                // +1 dans chaque stat suggérée
                for stat in background.suggestedStats {
                    stats[stat, default: 10] += 1
                }
            } else if backgroundBonusMode == .doublePlusOne {
                // +2 dans une stat, +1 dans une autre
                if !backgroundPlusTwoStat.isEmpty {
                    stats[backgroundPlusTwoStat, default: 10] += 2
                }
                if !backgroundPlusOneStat.isEmpty {
                    stats[backgroundPlusOneStat, default: 10] += 1
                }
            }
        }
        
        // Retourner les stats finales
        return (
            stats["Force"] ?? 10,
            stats["Dextérité"] ?? 10,
            stats["Constitution"] ?? 10,
            stats["Intelligence"] ?? 10,
            stats["Sagesse"] ?? 10,
            stats["Charisme"] ?? 10
        )
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
