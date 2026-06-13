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
                    
                    // Initiative
                    VStack {
                        Image(systemName: "bolt.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        Text("Initiative")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(character.initiative >= 0 ? "+\(character.initiative)" : "\(character.initiative)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow.opacity(0.1))
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
                
                // Taille + Perception Passive
                HStack(spacing: 12) {
                    // Catégorie de taille
                    VStack {
                        Image(systemName: "ruler")
                            .font(.title2)
                            .foregroundColor(.orange)
                        Text("Taille")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(character.size)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
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
                    
                    // Perception Passive
                    VStack {
                        Image(systemName: "eye.fill")
                            .font(.title2)
                            .foregroundColor(.cyan)
                        Text("Perception Passive")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(character.passivePerception)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan.opacity(0.1))
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
                    ForEach(sortedSkills(), id: \.name) { skill in
                        SkillRow(character: character, skill: skill)
                        if skill.name != sortedSkills().last?.name {
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
