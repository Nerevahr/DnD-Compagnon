import SwiftUI

/// Page affichant les aptitudes de classe et de race du personnage
struct AbilitiesPage: View {
    @Bindable var character: Character
    @State private var selectedClassAbility: ClassAbility?
    @State private var selectedRaceAbility: RaceAbility?
    @State private var isRaceSectionExpanded = true
    @State private var isClassSectionExpanded = true
    
    // Aptitudes de race
    var raceAbilities: [RaceAbility] {
        character.race?.abilities ?? []
    }
    
    // Aptitudes de classe disponibles jusqu'au niveau actuel
    var availableAbilities: [ClassAbility] {
        guard let dndClass = character.dndClass else { return [] }
        return dndClass.abilities.filter { $0.level <= character.level }
            .sorted { $0.level < $1.level }
    }
    
    // Grouper les aptitudes par niveau
    var abilitiesByLevel: [Int: [ClassAbility]] {
        Dictionary(grouping: availableAbilities, by: { $0.level })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section Aptitudes Raciales
                if !raceAbilities.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRaceSectionExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.orange)
                                Text("Aptitudes de race")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                if let raceName = character.race?.name {
                                    Text("(\(raceName))")
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.orange)
                                    .rotationEffect(.degrees(isRaceSectionExpanded ? 0 : -90))
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if isRaceSectionExpanded {
                            VStack(spacing: 8) {
                                ForEach(raceAbilities) { ability in
                                    RaceAbilityRow(ability: ability)
                                        .onTapGesture {
                                            selectedRaceAbility = ability
                                        }
                                }
                            }
                            .padding()
                            .background(Color.orange.opacity(0.05))
                            .cornerRadius(10)
                        }
                    }
                }
                
                // Section Aptitudes de Classe
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isClassSectionExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "shield.fill")
                                .foregroundColor(.blue)
                            Text("Aptitudes de classe")
                                .font(.title2)
                                .fontWeight(.bold)
                            if let className = character.dndClass?.name {
                                Text("(\(className))")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(isClassSectionExpanded ? 0 : -90))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if isClassSectionExpanded {
                        if availableAbilities.isEmpty {
                            EmptyAbilitiesView()
                        } else {
                            // Afficher les aptitudes groupées par niveau
                            ForEach(Array(abilitiesByLevel.keys.sorted()), id: \.self) { level in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Niveau \(level)")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    
                                    ForEach(abilitiesByLevel[level] ?? []) { ability in
                                        AbilityRow(ability: ability)
                                            .onTapGesture {
                                                selectedClassAbility = ability
                                            }
                                    }
                                }
                                .padding()
                                .background(Color.blue.opacity(0.05))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(item: $selectedClassAbility) { ability in
            AbilityDetailSheet(ability: ability)
        }
        .sheet(item: $selectedRaceAbility) { ability in
            RaceAbilityDetailSheet(ability: ability)
        }
    }
}
