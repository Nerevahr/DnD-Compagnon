//
//  CharacterDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var classes: [DnDClass]
    
    let character: Character
    
    @State private var isShowingEditSheet = false
    @State private var isSkillsSectionExpanded = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // En-tête
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        if let dndClass = character.dndClass {
                            Label(dndClass.name, systemImage: "shield.fill")
                                .foregroundColor(.blue)
                        }
                        if !character.race.isEmpty {
                            Label(character.race, systemImage: "person.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .font(.headline)
                    
                    if !character.origin.isEmpty {
                        Label(character.origin, systemImage: "book.fill")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                    
                    HStack {
                        Label("Niveau \(character.level)", systemImage: "star.fill")
                        Spacer()
                        Label("Bonus de maîtrise: +\(character.proficiencyBonus)", systemImage: "checkmark.seal.fill")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Caractéristiques
                VStack(alignment: .leading, spacing: 10) {
                    Text("Caractéristiques")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        StatCard(name: "Force", value: character.strength, modifier: character.strengthModifier)
                        StatCard(name: "Dextérité", value: character.dexterity, modifier: character.dexterityModifier)
                        StatCard(name: "Constitution", value: character.constitution, modifier: character.constitutionModifier)
                        StatCard(name: "Intelligence", value: character.intelligence, modifier: character.intelligenceModifier)
                        StatCard(name: "Sagesse", value: character.wisdom, modifier: character.wisdomModifier)
                        StatCard(name: "Charisme", value: character.charisma, modifier: character.charismaModifier)
                    }
                }
                
                // Jets de sauvegarde
                if let dndClass = character.dndClass, !dndClass.masteredStats.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Jets de sauvegarde")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            SavingThrowRow(character: character, stat: "Force")
                            SavingThrowRow(character: character, stat: "Dextérité")
                            SavingThrowRow(character: character, stat: "Constitution")
                            SavingThrowRow(character: character, stat: "Intelligence")
                            SavingThrowRow(character: character, stat: "Sagesse")
                            SavingThrowRow(character: character, stat: "Charisme")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                    }
                }
                
                // Section compétences rétractable
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        withAnimation {
                            isSkillsSectionExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("Compétences")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: isSkillsSectionExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if isSkillsSectionExpanded {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(Character.allSkills, id: \.name) { skill in
                                SkillRow(character: character, skill: skill)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                        .transition(.opacity)
                    }
                }
                
                // Informations
                VStack(alignment: .leading, spacing: 8) {
                    Text("Créé le")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(character.timestamp, format: Date.FormatStyle(date: .long, time: .shortened))
                        .font(.footnote)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Éditer") {
                    isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            CharacterEditView(character: character, availableClasses: classes)
        }
    }
}

struct StatCard: View {
    let name: String
    let value: Int
    let modifier: Int
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Modificateur en grand (mis en avant)
            Text(modifierString)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(modifier >= 0 ? .green : .red)
            
            // Valeur de la stat en petit (en dessous)
            Text("\(value)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SavingThrowRow: View {
    let character: Character
    let stat: String
    
    var isProficient: Bool {
        character.dndClass?.masteredStats.contains(stat) ?? false
    }
    
    var total: Int {
        character.savingThrow(for: stat)
    }
    
    var totalString: String {
        total >= 0 ? "+\(total)" : "\(total)"
    }
    
    var body: some View {
        HStack {
            if isProficient {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Text(stat)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(totalString)
                .fontWeight(isProficient ? .bold : .regular)
                .foregroundColor(isProficient ? .blue : .primary)
        }
    }
}

struct SkillRow: View {
    let character: Character
    let skill: DnDSkill
    
    var isProficient: Bool {
        character.proficientSkills.contains(skill.name)
    }
    
    var modifier: Int {
        character.skillModifier(for: skill)
    }
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var body: some View {
        HStack {
            if isProficient {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(skill.name)
                    .font(.body)
                Text(skill.baseStat)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(modifierString)
                .fontWeight(isProficient ? .bold : .regular)
                .foregroundColor(isProficient ? .green : .primary)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}
