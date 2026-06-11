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
    
    @Bindable var character: Character  // ← Changé de 'let' à '@Bindable'

    @State private var isShowingEditSheet = false
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête fixe avec infos du personnage
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
            .padding(.horizontal)
            .padding(.top)
            
            // Indicateur de page
            HStack(spacing: 8) {
                PageIndicator(title: "Caractéristiques", isActive: currentPage == 0)
                PageIndicator(title: "Sorts", isActive: currentPage == 1)
                PageIndicator(title: "Inventaire", isActive: currentPage == 2)
            }
            .padding(.vertical, 8)
            
            // TabView avec pages scrollables
            TabView(selection: $currentPage) {
                // Page 1 : Stats + Compétences + CA/Vitesse
                StatsAndSkillsPage(character: character)
                    .tag(0)
                
                // Page 2 : Sorts préparés
                SpellsPage(character: character)
                    .tag(1)
                
                // Page 3 : Inventaire
                InventoryPage(character: character)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
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

// MARK: - Page Indicator
struct PageIndicator: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(isActive ? .bold : .regular)
                .foregroundColor(isActive ? .blue : .secondary)
            
            Rectangle()
                .fill(isActive ? Color.blue : Color.clear)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Page 1: Stats + Skills (fusionnées)
struct StatsAndSkillsPage: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // CA + Vitesse + Bonus de maîtrise
                HStack(spacing: 12) {
                    VStack {
                        Image(systemName: "shield.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("CA")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("10")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Vitesse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("9m")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    
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
                
                // Caractéristiques
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
                
                // Jets de sauvegarde
                if let dndClass = character.dndClass, !dndClass.masteredStats.isEmpty {
                    Text("Jets de sauvegarde")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
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

// MARK: - Page 2: Spells
struct SpellsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSpells: [Spell]
    
    @Bindable var character: Character
    @State private var isShowingSpellPicker = false
    
    var availableSpells: [Spell] {
        guard let className = character.dndClass?.name else { return [] }
        return allSpells.filter { spell in
            spell.classes.contains(className) &&
            !character.preparedSpells.contains(where: { $0.id == spell.id })
        }
    }
    
    var spellsByLevel: [Int: [Spell]] {
        Dictionary(grouping: character.preparedSpells, by: { $0.niveau })
            .mapValues { $0.sorted { $0.name < $1.name } }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Sorts préparés")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { isShowingSpellPicker = true }) {
                        Label("Ajouter", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                }
                
                // Section caractéristique d'incantation
                if let dndClass = character.dndClass, !dndClass.spellcastingAbility.isEmpty {
                    VStack(spacing: 12) {
                        // Caractéristique d'incantation
                        HStack {
                            Text("Caractéristique d'incantation")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(dndClass.spellcastingAbility)
                                .font(.headline)
                                .foregroundColor(.purple)
                        }
                        
                        Divider()
                        
                        // DD et Bonus d'attaque
                        HStack(spacing: 20) {
                            // DD des sorts
                            VStack(spacing: 4) {
                                Text("DD des sorts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                let modifier = character.getModifier(for: dndClass.spellcastingAbility)
                                Text("\(8 + character.proficiencyBonus + modifier)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .frame(height: 40)
                            
                            // Bonus d'attaque
                            VStack(spacing: 4) {
                                Text("Bonus d'attaque")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                let modifier = character.getModifier(for: dndClass.spellcastingAbility)
                                let attackBonus = character.proficiencyBonus + modifier
                                Text(attackBonus >= 0 ? "+\(attackBonus)" : "\(attackBonus)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Liste des sorts préparés
                if character.preparedSpells.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(.purple.opacity(0.3))
                        Text("Aucun sort préparé")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Appuyez sur + pour ajouter des sorts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                } else {
                    ForEach(spellsByLevel.keys.sorted(), id: \.self) { level in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(level == 0 ? "Tours de magie" : "Niveau \(level)")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            ForEach(spellsByLevel[level] ?? [], id: \.id) { spell in
                                PreparedSpellRow(spell: spell) {
                                    removeSpell(spell)
                                }
                            }
                        }
                        .padding()
                        .background(Color.purple.opacity(0.05))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingSpellPicker) {
            SpellPickerView(character: character, availableSpells: availableSpells)
        }
    }
    
    private func removeSpell(_ spell: Spell) {
        withAnimation {
            if let index = character.preparedSpells.firstIndex(where: { $0.id == spell.id }) {
                character.preparedSpells.remove(at: index)
            }
        }
    }
}

// MARK: - Prepared Spell Row
struct PreparedSpellRow: View {
    let spell: Spell
    let onRemove: () -> Void
    
    @State private var isShowingDetail = false
    
    var body: some View {
        Button(action: { isShowingDetail = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(spell.name)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(spell.ecole)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if spell.concentration {
                            Label("C", systemImage: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        
                        Text(spell.formattedComponents)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $isShowingDetail) {
            SpellDetailSheet(spell: spell)
        }
    }
}

// MARK: - Spell Picker View
struct SpellPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var character: Character
    let availableSpells: [Spell]
    
    @State private var searchText = ""
    @State private var selectedLevel: Int? = nil
    @State private var showAllClasses = false
    
    @Query private var allSpells: [Spell]
    
    var spelllsToDisplay: [Spell] {
        if showAllClasses {
            // Tous les sorts moins ceux déjà préparés
            return allSpells.filter { spell in
                !character.preparedSpells.contains(where: { $0.id == spell.id })
            }
        } else {
            // Seulement les sorts de la classe du personnage
            return availableSpells
        }
    }
    
    var filteredSpells: [Spell] {
        var spells = spelllsToDisplay
        
        if !searchText.isEmpty {
            spells = spells.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let level = selectedLevel {
            spells = spells.filter { $0.niveau == level }
        }
        
        return spells.sorted { $0.name < $1.name }
    }
    
    var spellsByLevel: [Int: [Spell]] {
        Dictionary(grouping: filteredSpells, by: { $0.niveau })
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Toggle pour afficher toutes les classes
                HStack {
                    Toggle("Afficher tous les sorts", isOn: $showAllClasses)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                if !showAllClasses && character.dndClass == nil {
                    ContentUnavailableView(
                        "Aucune classe sélectionnée",
                        systemImage: "shield.slash",
                        description: Text("Sélectionnez une classe pour votre personnage ou activez 'Afficher tous les sorts'.")
                    )
                } else if filteredSpells.isEmpty {
                    ContentUnavailableView(
                        "Aucun sort trouvé",
                        systemImage: "sparkles",
                        description: Text("Modifiez vos critères de recherche ou tous les sorts sont déjà préparés.")
                    )
                } else {
                    List {
                        ForEach(spellsByLevel.keys.sorted(), id: \.self) { level in
                            Section(level == 0 ? "Tours de magie" : "Niveau \(level)") {
                                ForEach(spellsByLevel[level] ?? [], id: \.id) { spell in
                                    Button(action: {
                                        addSpell(spell)
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(spell.name)
                                                    .font(.body)
                                                
                                                HStack(spacing: 8) {
                                                    Text(spell.ecole)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                    
                                                    if spell.concentration {
                                                        Label("C", systemImage: "circle.fill")
                                                            .font(.caption2)
                                                            .foregroundColor(.orange)
                                                    }
                                                    
                                                    // Afficher les classes si mode "tous les sorts"
                                                    if showAllClasses {
                                                        Text("•")
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                        Text(spell.classes.prefix(2).joined(separator: ", "))
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un sort")
            .navigationTitle("Ajouter des sorts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addSpell(_ spell: Spell) {
        withAnimation {
            character.preparedSpells.append(spell)
        }
    }
}


// MARK: - Spell Detail Sheet
struct SpellDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let spell: Spell
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Niveau et école
                    HStack {
                        Text(spell.niveauLabel)
                            .font(.headline)
                            .foregroundColor(.purple)
                        Spacer()
                        Text(spell.ecole)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    // Infos rapides
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Temps d'incantation", value: spell.dureeIncantation)
                        InfoRow(label: "Portée", value: spell.portee)
                        InfoRow(label: "Composantes", value: spell.formattedComponents)
                        if spell.componentM && !spell.materialDescription.isEmpty {
                            InfoRow(label: "Matériel", value: spell.materialDescription)
                        }
                        InfoRow(label: "Durée", value: spell.duree)
                        if spell.concentration {
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.orange)
                                Text("Concentration")
                                    .foregroundColor(.orange)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Description
                    if !spell.descriptionSort.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(spell.descriptionSort)
                                .font(.body)
                        }
                    }
                    
                    // Classes
                    if !spell.classes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Classes")
                                .font(.headline)
                            Text(spell.classesLabel)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(spell.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}
// MARK: - Page 3: Inventory
struct InventoryPage: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Inventaire")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Or
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("Or")
                        .font(.headline)
                    Spacer()
                    Text("0")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("po")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                // Placeholder pour l'inventaire
                VStack(spacing: 12) {
                    Image(systemName: "backpack")
                        .font(.system(size: 50))
                        .foregroundColor(.orange.opacity(0.3))
                    Text("Inventaire vide")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Ajoutez des objets à votre inventaire")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - Composants réutilisables

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
                    .font(.body)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.body)
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
                .font(.title3)
                .fontWeight(isProficient ? .bold : .regular)
                .foregroundColor(isProficient ? .green : .primary)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
