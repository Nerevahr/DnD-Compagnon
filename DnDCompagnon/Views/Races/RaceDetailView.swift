//
//  RaceDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Races/RaceDetailView.swift
import SwiftUI
import SwiftData

struct RaceDetailView: View {
    @Bindable var race: Race
    @State private var isEditing = false

    var body: some View {
        Form {
            Section("Informations générales") {
                if isEditing {
                    TextField("Nom", text: $race.name)
                    TextField("Taille", text: $race.defaultSize)
                } else {
                    LabeledContent("Nom", value: race.name)
                    LabeledContent("Taille", value: race.defaultSize)
                    if let speed = race.speed {
                        LabeledContent("Vitesse", value: "\(speed) pieds")
                    }
                }
            }

            if !race.abilityBonuses.isEmpty {
                Section("Bonus de caractéristiques") {
                    ForEach(race.abilityBonuses.sorted(by: { $0.key < $1.key }), id: \.key) { stat, bonus in
                        LabeledContent(stat, value: bonus >= 0 ? "+\(bonus)" : "\(bonus)")
                    }
                }
            }

            Section("Aptitudes raciales") {
                if race.abilities.isEmpty {
                    Text("Aucune aptitude")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(race.abilities) { ability in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ability.name)
                                .font(.headline)
                            Text(ability.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(race.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation { isEditing.toggle() }
                }
            }
        }
    }
}