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
                            toolProficiency: toolProficiency
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
