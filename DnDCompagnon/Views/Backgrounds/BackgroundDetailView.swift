//
//  BackgroundDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Backgrounds/BackgroundDetailView.swift
import SwiftUI
import SwiftData

struct BackgroundDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var background: Background
    @State private var isEditing = false
    @State private var editingSkillProficiencies: Set<String> = []
    @Query(sort: \Feat.name) private var allFeats: [Feat]
    @Query(sort: \Item.name) private var allItems: [Item]

    // Pour ajouter une nouvelle option d'équipement
    @State private var showingAddEquipmentOption = false
    @State private var newOptionItemIDs: Set<PersistentIdentifier> = []
    @State private var newOptionGoldPieces: Double = 0

    let availableSkills = DnDSkill.allSkills.map { $0.name }

    private var originFeats: [Feat] {
        allFeats.filter { $0.type == .origine }
    }

    var body: some View {
        Form {
            Section("Informations générales") {
                if isEditing {
                    TextField("Nom", text: $background.name)
                    TextField("Description", text: $background.backgroundDescription, axis: .vertical)
                        .lineLimit(3...6)
                } else {
                    LabeledContent("Nom", value: background.name)
                    if !background.backgroundDescription.isEmpty {
                        Text(background.backgroundDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Statistiques suggérées") {
                if background.suggestedStats.isEmpty {
                    Text("Aucune statistique définie")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(background.suggestedStats, id: \.self) { stat in
                        Text(stat)
                    }
                }
            }

            Section("Maîtrise de compétences") {
                if isEditing {
                    ForEach(availableSkills, id: \.self) { skill in
                        HStack {
                            Text(skill)
                            Spacer()
                            if editingSkillProficiencies.contains(skill) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editingSkillProficiencies.contains(skill) {
                                editingSkillProficiencies.remove(skill)
                            } else {
                                editingSkillProficiencies.insert(skill)
                            }
                        }
                    }
                } else {
                    if background.skillProficiencies.isEmpty {
                        Text("Aucune")
                            .foregroundStyle(.secondary)
                            .italic()
                    } else {
                        ForEach(background.skillProficiencies, id: \.self) { skill in
                            Text("• \(skill)")
                        }
                    }
                }
            }

            Section("Maîtrise d'outil") {
                if isEditing {
                    TextField("Outil maîtrisé", text: $background.toolProficiency)
                } else {
                    Text(background.toolProficiency.isEmpty ? "Aucune" : background.toolProficiency)
                        .foregroundStyle(background.toolProficiency.isEmpty ? .secondary : .primary)
                }
            }

            Section("Don d'origine") {
                if isEditing {
                    Picker("Don associé (optionnel)", selection: $background.originFeat) {
                        Text("Aucun don").tag(nil as Feat?)
                        ForEach(originFeats) { feat in
                            Text(feat.name).tag(feat as Feat?)
                        }
                    }
                } else {
                    if let feat = background.originFeat {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(feat.name)
                                .font(.headline)
                            Text(feat.featDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Aucun")
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                }
            }

            Section("Options d'équipement") {
                if background.equipmentOptions.isEmpty {
                    Text("Aucune option définie")
                        .foregroundStyle(.secondary)
                        .italic()
                } else if isEditing {
                    ForEach(background.equipmentOptions) { option in
                        equipmentOptionRow(option)
                    }
                    .onDelete(perform: deleteEquipmentOptions)
                } else {
                    ForEach(background.equipmentOptions) { option in
                        equipmentOptionRow(option)
                    }
                }

                if isEditing {
                    Button {
                        showingAddEquipmentOption = true
                    } label: {
                        Label("Ajouter une option", systemImage: "plus.circle")
                    }
                }
            }
        }
        .navigationTitle(background.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        if isEditing {
                            background.skillProficiencies = Array(editingSkillProficiencies).sorted()
                        } else {
                            editingSkillProficiencies = Set(background.skillProficiencies)
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddEquipmentOption) {
            NavigationStack {
                Form {
                    Section("Or de départ") {
                        TextField("Or", value: $newOptionGoldPieces, format: .number)
                            .keyboardType(.numberPad)
                    }

                    Section("Objets") {
                        ForEach(allItems) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                if newOptionItemIDs.contains(item.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if newOptionItemIDs.contains(item.id) {
                                    newOptionItemIDs.remove(item.id)
                                } else {
                                    newOptionItemIDs.insert(item.id)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Nouvelle Option")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            resetNewOptionState()
                            showingAddEquipmentOption = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Ajouter") {
                            let items = allItems.filter { newOptionItemIDs.contains($0.id) }
                            let option = BackgroundEquipmentOption(
                                items: items,
                                goldPieces: newOptionGoldPieces
                            )
                            modelContext.insert(option)
                            background.equipmentOptions.append(option)
                            resetNewOptionState()
                            showingAddEquipmentOption = false
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func equipmentOptionRow(_ option: BackgroundEquipmentOption) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(Int(option.goldPieces)) po")
                .font(.headline)
            if !option.items.isEmpty {
                Text(option.items.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private func deleteEquipmentOptions(at offsets: IndexSet) {
        let optionsToDelete = offsets.map { background.equipmentOptions[$0] }
        background.equipmentOptions.remove(atOffsets: offsets)
        for option in optionsToDelete {
            modelContext.delete(option)
        }
    }

    private func resetNewOptionState() {
        newOptionItemIDs = []
        newOptionGoldPieces = 0
    }
}
