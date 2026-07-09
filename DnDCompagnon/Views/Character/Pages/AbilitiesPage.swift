import SwiftUI
import SwiftData

/// Page affichant les aptitudes de classe et de race du personnage
struct AbilitiesPage: View {
    @Bindable var character: Character
    @State private var selectedClassAbility: ClassAbility?
    @State private var selectedRaceAbility: RaceAbility?
    @State private var selectedFeat: Feat?
    @State private var isRaceSectionExpanded = true
    @State private var isClassSectionExpanded = true
    @State private var isFeatSectionExpanded = true
    @State private var isShowingFeatManager = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var allFeats: [Feat]
    
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
    
    // Don lié au background (à protéger de la suppression)
    var backgroundFeat: Feat? {
        character.origin?.originFeat
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
                
                // Section Dons
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isFeatSectionExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                            Text("Dons")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("(\(character.feats.count))")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.purple)
                                .rotationEffect(.degrees(isFeatSectionExpanded ? 0 : -90))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if isFeatSectionExpanded {
                        if character.feats.isEmpty {
                            VStack(alignment: .center, spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                Text("Aucun don")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else {
                            VStack(spacing: 8) {
                                ForEach(character.feats) { feat in
                                    FeatRow(feat: feat, isLocked: feat.id == backgroundFeat?.id)
                                        .onTapGesture {
                                            selectedFeat = feat
                                        }
                                }
                            }
                            .padding()
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                        }
                        
                        // Bouton pour gérer les dons
                        Button(action: { isShowingFeatManager = true }) {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                Text("Gérer les dons")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
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
        .sheet(item: $selectedFeat) { feat in
            FeatDetailSheet(feat: feat)
        }
        .sheet(isPresented: $isShowingFeatManager) {
            FeatManageView(character: character, allFeats: allFeats, backgroundFeat: backgroundFeat)
        }
    }
}
