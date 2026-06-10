//
//  SpellListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct SpellListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var spells: [Spell]

    @State private var isShowingAddSheet = false

    // Formulaire d'ajout
    @State private var newSpellName = ""
    @State private var newSpellPortee = ""
    @State private var newSpellEcole = "Évocation"
    @State private var newSpellV = false
    @State private var newSpellS = false
    @State private var newSpellM = false
    @State private var newSpellMaterialDescription = ""
    @State private var newSpellDuree = ""
    @State private var newSpellNiveau = 1
    @State private var newSpellClasses: Set<String> = []
    @State private var newSpellConcentration = false
    @State private var newSpellDescription = ""
    // Filtres
    @State private var isShowingFilterSheet = false
    @State private var filterNiveaux: Set<Int> = []
    @State private var filterClasses: Set<String> = []
    @State private var filterEcoles: Set<String> = []
    @State private var filterConcentration: Bool? = nil // nil = pas de filtre, true/false = filtré

    let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]
    
    // Filtrer les sorts selon les critères actifs
    private var filteredSpells: [Spell] {
        spells.filter { spell in
            // Filtre par niveau
            if !filterNiveaux.isEmpty && !filterNiveaux.contains(spell.niveau) {
                return false
            }
            
            // Filtre par classe
            if !filterClasses.isEmpty {
                let hasMatchingClass = spell.classes.contains { filterClasses.contains($0) }
                if !hasMatchingClass {
                    return false
                }
            }
            
            // Filtre par école
            if !filterEcoles.isEmpty && !filterEcoles.contains(spell.ecole) {
                return false
            }
            
            // Filtre par concentration
            if let needsConcentration = filterConcentration {
                if spell.concentration != needsConcentration {
                    return false
                }
            }
            
            return true
        }
    }

    // Grouper les sorts filtrés par niveau
    private var groupedSpells: [Int: [Spell]] {
        Dictionary(grouping: filteredSpells, by: { $0.niveau })
    }
    
    private var hasActiveFilters: Bool {
        !filterNiveaux.isEmpty || !filterClasses.isEmpty ||
        !filterEcoles.isEmpty || filterConcentration != nil
    }

    private var activeFilterCount: Int {
        var count = 0
        if !filterNiveaux.isEmpty { count += filterNiveaux.count }
        if !filterClasses.isEmpty { count += filterClasses.count }
        if !filterEcoles.isEmpty { count += filterEcoles.count }
        if filterConcentration != nil { count += 1 }
        return count
    }
      
    // Obtenir les niveaux triés
    private var sortedLevels: [Int] {
        groupedSpells.keys.sorted()
      }

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(sortedLevels, id: \.self) { niveau in
                    Section(header: Text(niveauSectionHeader(niveau))) {
                        ForEach(groupedSpells[niveau] ?? []) { spell in
                            NavigationLink {
                                SpellDetailView(spell: spell)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(spell.name)
                                            .font(.headline)
                                        Spacer()
                                        if spell.concentration {
                                            Image(systemName: "c.circle.fill")
                                                .foregroundColor(.orange)
                                                .help("Concentration")
                                        }
                                    }
                                    HStack {
                                        Text("• \(spell.portee)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Text("• \(spell.formattedComponents)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteSpells(at: indexSet, in: niveau)
                        }
                    }
                }
            }
            .navigationTitle("Sorts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isShowingFilterSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            if hasActiveFilters {
                                Text("\(activeFilterCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowingAddSheet = true }) {
                        Label("Ajouter un sort", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingFilterSheet) {
                NavigationStack {
                    Form {
                        // --- Filtrer par niveau ---
                        Section(header: Text("Niveau")) {
                            ForEach(0...9, id: \.self) { niveau in
                                HStack {
                                    Text(niveau == 0 ? "Tour de magie" : "Niveau \(niveau)")
                                    Spacer()
                                    if filterNiveaux.contains(niveau) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if filterNiveaux.contains(niveau) {
                                        filterNiveaux.remove(niveau)
                                    } else {
                                        filterNiveaux.insert(niveau)
                                    }
                                }
                            }
                        }
                        
                        // --- Filtrer par classe ---
                        Section(header: Text("Classes")) {
                            ForEach(Spell.classesDnD, id: \.self) { classe in
                                HStack {
                                    Text(classe)
                                    Spacer()
                                    if filterClasses.contains(classe) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if filterClasses.contains(classe) {
                                        filterClasses.remove(classe)
                                    } else {
                                        filterClasses.insert(classe)
                                    }
                                }
                            }
                        }
                        
                        // --- Filtrer par école ---
                        Section(header: Text("École de magie")) {
                            ForEach(ecolesDeMagie, id: \.self) { ecole in
                                HStack {
                                    Text(ecole)
                                    Spacer()
                                    if filterEcoles.contains(ecole) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if filterEcoles.contains(ecole) {
                                        filterEcoles.remove(ecole)
                                    } else {
                                        filterEcoles.insert(ecole)
                                    }
                                }
                            }
                        }
                        
                        // --- Filtrer par concentration ---
                        Section(header: Text("Concentration")) {
                            ForEach([("Tous", nil as Bool?), ("Avec concentration", true), ("Sans concentration", false)], id: \.0) { option in
                                HStack {
                                    Text(option.0)
                                    Spacer()
                                    if filterConcentration == option.1 {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    filterConcentration = option.1
                                }
                            }
                        }
                    }
                    .navigationTitle("Filtres")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Fermer") {
                                isShowingFilterSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Réinitialiser") {
                                filterNiveaux = []
                                filterClasses = []
                                filterEcoles = []
                                filterConcentration = nil
                            }
                            .disabled(!hasActiveFilters)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                NavigationStack {
                    Form {
                        // --- Détails généraux ---
                        Section(header: Text("Détails du Sort")) {
                            TextField("Nom du sort", text: $newSpellName)

                            Picker("École de magie", selection: $newSpellEcole) {
                                ForEach(ecolesDeMagie, id: \.self) { ecole in
                                    Text(ecole).tag(ecole)
                                }
                            }

                            // Niveau : 0 = Tour de magie, 1-9
                            Picker("Niveau", selection: $newSpellNiveau) {
                                Text("Tour de magie").tag(0)
                                ForEach(1...9, id: \.self) { n in
                                    Text("Niveau \(n)").tag(n)
                                }
                            }
                        }

                        // --- Paramètres ---
                        Section(header: Text("Paramètres")) {
                            TextField("Portée", text: $newSpellPortee)
                            TextField("Durée d'incantation", text: $newSpellDuree)
                            Toggle("Concentration", isOn: $newSpellConcentration)
                        }

                        // --- Composantes ---
                        Section(header: Text("Composantes")) {
                            Toggle("Verbal (V)", isOn: $newSpellV)
                            Toggle("Somatique (S)", isOn: $newSpellS)
                            Toggle("Matériel (M)", isOn: $newSpellM)

                            if newSpellM {
                                TextField("Spécifiez le matériel (ex: une plume)", text: $newSpellMaterialDescription)
                                    .transition(.opacity)
                            }
                        }

                        // --- Classes ---
                        Section(header: Text("Classes")) {
                            ForEach(Spell.classesDnD, id: \.self) { classe in
                                HStack {
                                    Text(classe)
                                    Spacer()
                                    if newSpellClasses.contains(classe) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if newSpellClasses.contains(classe) {
                                        newSpellClasses.remove(classe)
                                    } else {
                                        newSpellClasses.insert(classe)
                                    }
                                }
                            }
                        }

                        // --- Description ---
                        Section(header: Text("Description")) {
                            TextEditor(text: $newSpellDescription)
                                .frame(minHeight: 120)
                        }
                    }
                    .navigationTitle("Nouveau Sort")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                isShowingAddSheet = false
                                resetForm()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Ajouter") {
                                addSpell()
                                isShowingAddSheet = false
                                resetForm()
                            }
                            .disabled(newSpellName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        } detail: {
            Text("Sélectionnez un sort")
        }
    }

    // MARK: - Helpers

    private func addSpell() {
        withAnimation {
            let newSpell = Spell(
                timestamp: Date(),
                name: newSpellName,
                portee: newSpellPortee.isEmpty ? "Personnelle" : newSpellPortee,
                ecole: newSpellEcole,
                componentV: newSpellV,
                componentS: newSpellS,
                componentM: newSpellM,
                materialDescription: newSpellM ? newSpellMaterialDescription : "",
                dureeIncantation: newSpellDuree.isEmpty ? "1 action" : newSpellDuree,
                niveau: newSpellNiveau,
                classes: Array(newSpellClasses).sorted(),
                concentration: newSpellConcentration,
                descriptionSort: newSpellDescription
            )
            modelContext.insert(newSpell)
        }
    }

    private func deleteSpells(at offsets: IndexSet, in niveau: Int) {
        withAnimation {
            let spellsInSection = groupedSpells[niveau] ?? []
            for index in offsets {
                modelContext.delete(spellsInSection[index])
            }
        }
    }
    
    // Helper pour le header de section
    private func niveauSectionHeader(_ niveau: Int) -> String {
        if niveau == 0 {
            return "Tours de magie"
        } else {
            return "Niveau \(niveau)"
        }
    }
    

    private func resetForm() {
        newSpellName = ""
        newSpellPortee = ""
        newSpellEcole = "Évocation"
        newSpellV = false
        newSpellS = false
        newSpellM = false
        newSpellMaterialDescription = ""
        newSpellDuree = ""
        newSpellNiveau = 1
        newSpellClasses = []
        newSpellConcentration = false
        newSpellDescription = ""
    }
}

// MARK: - VUE DE DÉTAIL AVEC MODE LECTURE / ÉDITION
struct SpellDetailView: View {
    @Bindable var spell: Spell

    @State private var isEditing = false
    // État local pour la sélection de classes en mode édition
    @State private var editingClasses: Set<String> = []

    let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    var body: some View {
        Form {
            // --- Informations générales ---
            Section(header: Text("Informations Générales")) {
                if isEditing {
                    TextField("Nom du sort", text: $spell.name)
                    Picker("École de magie", selection: $spell.ecole) {
                        ForEach(ecolesDeMagie, id: \.self) { ecole in
                            Text(ecole).tag(ecole)
                        }
                    }
                    Picker("Niveau", selection: $spell.niveau) {
                        Text("Tour de magie").tag(0)
                        ForEach(1...9, id: \.self) { n in
                            Text("Niveau \(n)").tag(n)
                        }
                    }
                } else {
                    LabeledContent("Nom", value: spell.name)
                    LabeledContent("École", value: spell.ecole)
                    LabeledContent("Niveau", value: spell.niveauLabel)
                }
            }

            // --- Caractéristiques de lancement ---
            Section(header: Text("Caractéristiques de Lancement")) {
                if isEditing {
                    TextField("Portée", text: $spell.portee)
                    TextField("Durée d'incantation", text: $spell.dureeIncantation)
                    Toggle("Concentration", isOn: $spell.concentration)
                } else {
                    LabeledContent("Portée", value: spell.portee)
                    LabeledContent("Incantation", value: spell.dureeIncantation)
                    LabeledContent("Concentration", value: spell.concentration ? "Oui" : "Non")
                }
            }

            // --- Composantes ---
            Section(header: Text("Composantes")) {
                if isEditing {
                    Toggle("Verbal (V)", isOn: $spell.componentV)
                    Toggle("Somatique (S)", isOn: $spell.componentS)
                    Toggle("Matériel (M)", isOn: $spell.componentM)

                    if spell.componentM {
                        TextField("Spécifiez le matériel", text: $spell.materialDescription)
                            .transition(.opacity)
                    }
                } else {
                    LabeledContent("Composantes", value: spell.formattedComponents)

                    if spell.componentM && !spell.materialDescription.isEmpty {
                        LabeledContent("Détail du matériel", value: spell.materialDescription)
                    }
                }
            }

            // --- Classes ---
            Section(header: Text("Classes")) {
                if isEditing {
                    ForEach(Spell.classesDnD, id: \.self) { classe in
                        HStack {
                            Text(classe)
                            Spacer()
                            if editingClasses.contains(classe) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editingClasses.contains(classe) {
                                editingClasses.remove(classe)
                            } else {
                                editingClasses.insert(classe)
                            }
                        }
                    }
                } else {
                    LabeledContent("Classes", value: spell.classesLabel)
                }
            }

            // --- Description ---
            Section(header: Text("Description")) {
                if isEditing {
                    TextEditor(text: $spell.descriptionSort)
                        .frame(minHeight: 120)
                } else {
                    if spell.descriptionSort.isEmpty {
                        Text("Aucune description")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Text(spell.descriptionSort)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        if isEditing {
                            // Valider les modifications
                            spell.classes = Array(editingClasses).sorted()
                            if !spell.componentM {
                                spell.materialDescription = ""
                            }
                        } else {
                            // Entrer en édition : initialiser l'état local
                            editingClasses = Set(spell.classes)
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}
