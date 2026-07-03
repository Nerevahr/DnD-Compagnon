//
//  AddRaceView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Races/AddRaceView.swift
import SwiftUI
import SwiftData

struct AddRaceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var defaultSize = "Moyen"
    @State private var speed: Int = 30

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations générales") {
                    TextField("Nom de la race", text: $name)
                    TextField("Taille", text: $defaultSize)
                    Stepper("Vitesse: \(speed) pieds", value: $speed, in: 0...60, step: 5)
                }
            }
            .navigationTitle("Nouvelle Race")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        modelContext.insert(Race(name: name, speed: speed, defaultSize: defaultSize))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}