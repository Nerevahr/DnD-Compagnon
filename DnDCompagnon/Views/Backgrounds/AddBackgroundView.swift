//
//  AddBackgroundView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Backgrounds/AddBackgroundView.swift
import SwiftUI
import SwiftData

struct AddBackgroundView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""
    @State private var featureName = ""
    @State private var featureDescription = ""
    @State private var toolProficiency = ""
    @State private var selectedOriginFeat: Feat?
    
    @Query(sort: \Feat.name) private var allFeats: [Feat]
    
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
                Section("Aptitude") {
                    TextField("Nom de l'aptitude", text: $featureName)
                    TextField("Description de l'aptitude", text: $featureDescription, axis: .vertical)
                        .lineLimit(3...6)
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
            }
            .navigationTitle("Nouvelle Origine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let feature = BackgroundAbility(name: featureName, abilityDescription: featureDescription)
                        let background = Background(
                            name: name,
                            description: description,
                            feature: feature,
                            toolProficiency: toolProficiency,
                            originFeat: selectedOriginFeat
                        )
                        modelContext.insert(background)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
