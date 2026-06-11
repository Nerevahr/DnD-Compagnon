//
//  StatsAndSkillsPage.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


import SwiftUI

/// Page affichant les caractéristiques, jets de sauvegarde et compétences
struct StatsAndSkillsPage: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // CA + Vitesse + Bonus de maîtrise
                HStack(spacing: 12) {
                    // Classe d'Armure
                    VStack {
                        Image(systemName: "shield.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("CA")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(character.armorClass)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Vitesse
                    VStack {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Vitesse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(character.speedInMeters)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Bonus de maîtrise
                    VStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                        Text("Maîtrise")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("+\(character.proficiencyBonus)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Caractéristiques avec jets de sauvegarde intégrés
                Text("Caractéristiques")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    StatCard(
                        name: "Force",
                        value: character.strength,
                        modifier: character.strengthModifier,
                        savingThrowBonus: character.savingThrow(for: "Force"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Force") ?? false
                    )
                    StatCard(
                        name: "Dextérité",
                        value: character.dexterity,
                        modifier: character.dexterityModifier,
                        savingThrowBonus: character.savingThrow(for: "Dextérité"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Dextérité") ?? false
                    )
                    StatCard(
                        name: "Constitution",
                        value: character.constitution,
                        modifier: character.constitutionModifier,
                        savingThrowBonus: character.savingThrow(for: "Constitution"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Constitution") ?? false
                    )
                    StatCard(
                        name: "Intelligence",
                        value: character.intelligence,
                        modifier: character.intelligenceModifier,
                        savingThrowBonus: character.savingThrow(for: "Intelligence"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Intelligence") ?? false
                    )
                    StatCard(
                        name: "Sagesse",
                        value: character.wisdom,
                        modifier: character.wisdomModifier,
                        savingThrowBonus: character.savingThrow(for: "Sagesse"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Sagesse") ?? false
                    )
                    StatCard(
                        name: "Charisme",
                        value: character.charisma,
                        modifier: character.charismaModifier,
                        savingThrowBonus: character.savingThrow(for: "Charisme"),
                        isProficientInSavingThrow: character.dndClass?.masteredStats.contains("Charisme") ?? false
                    )
                }
                
                // Compétences
                Text("Compétences")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 0) {
                    ForEach(Character.allSkills, id: \.name) { skill in
                        SkillRow(character: character, skill: skill)
                        if skill.name != Character.allSkills.last?.name {
                            Divider()
                                .padding(.leading, 40)
                        }
                    }
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}
