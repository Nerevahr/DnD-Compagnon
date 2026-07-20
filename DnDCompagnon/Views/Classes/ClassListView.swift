//
//  ClassListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//


import SwiftUI
import SwiftData

struct ClassListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DnDClass.name) private var classes: [DnDClass]
    @State private var showingAddClass = false
    
    let resourceSelector: AnyView
    
    var body: some View {
        List {
            ForEach(classes) { dndClass in
                NavigationLink(destination: ClassDetailView(dndClass: dndClass)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dndClass.name)
                            .font(.headline)
                        if !dndClass.spellcastingAbility.isEmpty {
                            Text("Incantation: \(dndClass.spellcastingAbility)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteClasses)
        }
        .navigationTitle("Classes")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                resourceSelector
            }
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddClass = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddClass) {
            AddClassView()
        }
    }
    
    private func deleteClasses(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(classes[index])
        }
    }
}

// MARK: - Vue d'Ajout de Classe
struct AddClassView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var descriptionClass = ""
    @State private var spellcastingAbility = ""
    @State private var masteredStats: Set<String> = []
    @State private var masteredSkills: Set<String> = []
    @State private var abilities: [ClassAbility] = []
    
    // Pour ajouter une nouvelle aptitude
    @State private var showingAddAbility = false
    @State private var newAbilityLevel = 1
    @State private var newAbilityName = ""
    @State private var newAbilityDescription = ""
    
    let availableStats = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
    let availableSkills = [
        "Acrobaties", "Arcanes", "Athlétisme", "Discrétion", "Dressage",
        "Escamotage", "Histoire", "Intimidation", "Investigation", "Médecine",
        "Nature", "Perception", "Intuition", "Persuasion", "Religion",
        "Représentation", "Survie", "Tromperie"
    ]
    let spellcastingAbilities = ["", "Intelligence", "Sagesse", "Charisme"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations Générales")) {
                    TextField("Nom de la classe", text: $name)
                    
                    Picker("Caractéristique d'incantation", selection: $spellcastingAbility) {
                        Text("Aucune").tag("")
                        ForEach(spellcastingAbilities.filter { !$0.isEmpty }, id: \.self) { ability in
                            Text(ability).tag(ability)
                        }
                    }
                }
                
                Section(header: Text("Statistiques Maîtrisées")) {
                    ForEach(availableStats, id: \.self) { stat in
                        HStack {
                            Text(stat)
                            Spacer()
                            if masteredStats.contains(stat) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if masteredStats.contains(stat) {
                                masteredStats.remove(stat)
                            } else {
                                masteredStats.insert(stat)
                            }
                        }
                    }
                }
                
                Section(header: Text("Compétences Maîtrisées")) {
                    ForEach(availableSkills, id: \.self) { skill in
                        HStack {
                            Text(skill)
                            Spacer()
                            if masteredSkills.contains(skill) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if masteredSkills.contains(skill) {
                                masteredSkills.remove(skill)
                            } else {
                                masteredSkills.insert(skill)
                            }
                        }
                    }
                }
                
                Section(header: Text("Aptitudes par Niveau")) {
                    ForEach(abilities.sorted(by: { $0.level < $1.level }), id: \.self) { ability in
                        HStack {
                            Text("Niv. \(ability.level)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 50, alignment: .leading)
                            Text(ability.name)
                        }
                    }
                    .onDelete { indexSet in
                        abilities.remove(atOffsets: indexSet)
                    }
                    
                    Button {
                        showingAddAbility = true
                    } label: {
                        Label("Ajouter une aptitude", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $descriptionClass)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Nouvelle Classe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        addDnDClass()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $showingAddAbility) {
                NavigationStack {
                    Form {
                        Picker("Niveau", selection: $newAbilityLevel) {
                            ForEach(1...20, id: \.self) { level in
                                Text("Niveau \(level)").tag(level)
                            }
                        }
                        
                        TextField("Nom de l'aptitude", text: $newAbilityName)
                        
                        Section(header: Text("Description")) {
                            TextEditor(text: $newAbilityDescription)
                                .frame(minHeight: 80)
                        }
                    }
                    .navigationTitle("Nouvelle Aptitude")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                showingAddAbility = false
                                newAbilityName = ""
                                newAbilityDescription = ""
                                newAbilityLevel = 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Ajouter") {
                                abilities.append(ClassAbility(
                                    level: newAbilityLevel,
                                    name: newAbilityName,
                                    description: newAbilityDescription.isEmpty ? nil : newAbilityDescription
                                ))
                                showingAddAbility = false
                                newAbilityName = ""
                                newAbilityDescription = ""
                                newAbilityLevel = 1
                            }
                            .disabled(newAbilityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
    
    private func addDnDClass() {
        let newClass = DnDClass(
            name: name,
            descriptionClass: descriptionClass,
            abilities: abilities,
            masteredStats: Array(masteredStats).sorted(),
            spellcastingAbility: spellcastingAbility,
            masteredSkills: Array(masteredSkills).sorted()
        )
        modelContext.insert(newClass)
    }
}

// MARK: - Vue de Détail de Classe
struct ClassDetailView: View {
    @Bindable var dndClass: DnDClass
    @State private var isEditing = false
    @State private var editingMasteredStats: Set<String> = []
    @State private var editingMasteredSkills: Set<String> = []
    @State private var editingAbilities: [ClassAbility] = []
    
    // Pour ajouter une nouvelle aptitude
    @State private var showingAddAbility = false
    @State private var newAbilityLevel = 1
    @State private var newAbilityName = ""
    @State private var newAbilityDescription = ""
    
    let availableStats = ["Force", "Dextérité", "Constitution", "Intelligence", "Sagesse", "Charisme"]
    let availableSkills = [
        "Acrobaties", "Arcanes", "Athlétisme", "Discrétion", "Dressage",
        "Escamotage", "Histoire", "Intimidation", "Investigation", "Médecine",
        "Nature", "Perception", "Intuition", "Persuasion", "Religion",
        "Représentation", "Survie", "Tromperie"
    ]
    let spellcastingAbilities = ["", "Intelligence", "Sagesse", "Charisme"]
    
    var body: some View {
        Form {
            Section(header: Text("Informations Générales")) {
                if isEditing {
                    TextField("Nom", text: $dndClass.name)
                    Picker("Caractéristique d'incantation", selection: $dndClass.spellcastingAbility) {
                        Text("Aucune").tag("")
                        ForEach(spellcastingAbilities.filter { !$0.isEmpty }, id: \.self) { ability in
                            Text(ability).tag(ability)
                        }
                    }
                } else {
                    LabeledContent("Nom", value: dndClass.name)
                    LabeledContent("Incantation", value: dndClass.spellcastingAbility.isEmpty ? "Aucune" : dndClass.spellcastingAbility)
                }
            }
            
            Section(header: Text("Statistiques Maîtrisées")) {
                if isEditing {
                    ForEach(availableStats, id: \.self) { stat in
                        HStack {
                            Text(stat)
                            Spacer()
                            if editingMasteredStats.contains(stat) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editingMasteredStats.contains(stat) {
                                editingMasteredStats.remove(stat)
                            } else {
                                editingMasteredStats.insert(stat)
                            }
                        }
                    }
                } else {
                    if dndClass.masteredStats.isEmpty {
                        Text("Aucune")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Text(dndClass.masteredStats.joined(separator: ", "))
                    }
                }
            }
            
            Section(header: Text("Compétences Maîtrisées")) {
                if isEditing {
                    ForEach(availableSkills, id: \.self) { skill in
                        HStack {
                            Text(skill)
                            Spacer()
                            if editingMasteredSkills.contains(skill) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editingMasteredSkills.contains(skill) {
                                editingMasteredSkills.remove(skill)
                            } else {
                                editingMasteredSkills.insert(skill)
                            }
                        }
                    }
                } else {
                    if dndClass.masteredSkills.isEmpty {
                        Text("Aucune")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(dndClass.masteredSkills, id: \.self) { skill in
                            Text("• \(skill)")
                        }
                    }
                }
            }
            
            Section(header: Text("Aptitudes par Niveau")) {
                if isEditing {
                    ForEach(editingAbilities.sorted(by: { $0.level < $1.level }), id: \.self) { ability in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Niv. \(ability.level)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 50, alignment: .leading)
                                Text(ability.name)
                                    .fontWeight(.semibold)
                            }
                            if let description = ability.description, !description.isEmpty {
                                Text(description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                        }
                    }
                    .onDelete { indexSet in
                        let sortedAbilities = editingAbilities.sorted(by: { $0.level < $1.level })
                        for index in indexSet {
                            if let originalIndex = editingAbilities.firstIndex(of: sortedAbilities[index]) {
                                editingAbilities.remove(at: originalIndex)
                            }
                        }
                    }
                    
                    Button {
                        showingAddAbility = true
                    } label: {
                        Label("Ajouter une aptitude", systemImage: "plus.circle")
                    }
                } else {
                    if dndClass.abilities.isEmpty {
                        Text("Aucune aptitude définie")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(dndClass.abilities.sorted(by: { $0.level < $1.level }), id: \.self) { ability in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Niv. \(ability.level)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(width: 50, alignment: .leading)
                                    Text(ability.name)
                                        .fontWeight(.semibold)
                                }
                                if let description = ability.description, !description.isEmpty {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Description")) {
                if isEditing {
                    TextEditor(text: $dndClass.descriptionClass)
                        .frame(minHeight: 100)
                } else {
                    if dndClass.descriptionClass.isEmpty {
                        Text("Aucune description")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Text(dndClass.descriptionClass)
                    }
                }
            }
        }
        .navigationTitle(dndClass.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        if isEditing {
                            dndClass.masteredStats = Array(editingMasteredStats).sorted()
                            dndClass.masteredSkills = Array(editingMasteredSkills).sorted()
                            dndClass.abilities = editingAbilities
                        } else {
                            editingMasteredStats = Set(dndClass.masteredStats)
                            editingMasteredSkills = Set(dndClass.masteredSkills)
                            editingAbilities = dndClass.abilities
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAbility) {
            NavigationStack {
                Form {
                    Picker("Niveau", selection: $newAbilityLevel) {
                        ForEach(1...20, id: \.self) { level in
                            Text("Niveau \(level)").tag(level)
                        }
                    }
                    
                    TextField("Nom de l'aptitude", text: $newAbilityName)
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $newAbilityDescription)
                            .frame(minHeight: 80)
                    }
                }
                .navigationTitle("Nouvelle Aptitude")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            showingAddAbility = false
                            newAbilityName = ""
                            newAbilityDescription = ""
                            newAbilityLevel = 1
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Ajouter") {
                            editingAbilities.append(ClassAbility(
                                level: newAbilityLevel,
                                name: newAbilityName,
                                description: newAbilityDescription.isEmpty ? nil : newAbilityDescription
                            ))
                            showingAddAbility = false
                            newAbilityName = ""
                            newAbilityDescription = ""
                            newAbilityLevel = 1
                        }
                        .disabled(newAbilityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }
}
