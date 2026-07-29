//
//  AddBackgroundView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Backgrounds/AddBackgroundView.swift
import SwiftUI
import SwiftData

/// Option d'équipement en cours de construction dans le formulaire d'ajout
private struct DraftEquipmentOption: Identifiable {
    let id = UUID()
    var itemIDs: Set<PersistentIdentifier>
    var goldPieces: Double
}

struct AddBackgroundView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""
    @State private var toolProficiency = ""
    @State private var skillProficiencies: Set<String> = []
    @State private var selectedOriginFeat: Feat?
    @State private var equipmentOptions: [DraftEquipmentOption] = []

    // Pour ajouter une nouvelle option d'équipement
    @State private var showingAddEquipmentOption = false
    @State private var newOptionItemIDs: Set<PersistentIdentifier> = []
    @State private var newOptionGoldPieces: Double = 0

    @Query(sort: \Feat.name) private var allFeats: [Feat]
    @Query(sort: \Item.name) private var allItems: [Item]

    let availableSkills = DnDSkill.allSkills.map { $0.name }

    private var originFeats: [Feat] {
        allFeats.filter { $0.type == .origine }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations générales") {
                    TextField("Nom de l'origine", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Maîtrise de compétences") {
                    ForEach(availableSkills, id: \.self) { skill in
                        HStack {
                            Text(skill)
                            Spacer()
                            if skillProficiencies.contains(skill) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if skillProficiencies.contains(skill) {
                                skillProficiencies.remove(skill)
                            } else {
                                skillProficiencies.insert(skill)
                            }
                        }
                    }
                }

                Section("Maîtrise d'outil") {
                    TextField("Ex: Outils de voleur", text: $toolProficiency)
                }

                Section("Don d'origine") {
                    Picker("Don associé (optionnel)", selection: $selectedOriginFeat) {
                        Text("Aucun don").tag(nil as Feat?)
                        ForEach(originFeats) { feat in
                            Text(feat.name).tag(feat as Feat?)
                        }
                    }
                }

                Section("Options d'équipement") {
                    ForEach(equipmentOptions) { option in
                        Text("\(option.itemIDs.count) objet(s) · \(Int(option.goldPieces)) po")
                    }
                    .onDelete { indexSet in
                        equipmentOptions.remove(atOffsets: indexSet)
                    }

                    Button {
                        showingAddEquipmentOption = true
                    } label: {
                        Label("Ajouter une option", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Nouvelle Origine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let resolvedOptions = equipmentOptions.map { draft -> BackgroundEquipmentOption in
                            let items = allItems.filter { draft.itemIDs.contains($0.id) }
                            let option = BackgroundEquipmentOption(
                                items: items,
                                goldPieces: draft.goldPieces
                            )
                            modelContext.insert(option)
                            return option
                        }
                        let background = Background(
                            name: name,
                            description: description,
                            toolProficiency: toolProficiency,
                            skillProficiencies: Array(skillProficiencies).sorted(),
                            originFeat: selectedOriginFeat,
                            equipmentOptions: resolvedOptions
                        )
                        modelContext.insert(background)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
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
                                equipmentOptions.append(DraftEquipmentOption(
                                    itemIDs: newOptionItemIDs,
                                    goldPieces: newOptionGoldPieces
                                ))
                                resetNewOptionState()
                                showingAddEquipmentOption = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func resetNewOptionState() {
        newOptionItemIDs = []
        newOptionGoldPieces = 0
    }
}
