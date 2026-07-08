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
    @Bindable var background: Background
    @State private var isEditing = false
    @Query(sort: \Feat.name) private var allFeats: [Feat]
    
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

            Section("Aptitude") {
                VStack(alignment: .leading, spacing: 6) {
                    if isEditing {
                        TextField("Nom de l'aptitude", text: $background.feature.name)
                        TextField("Description", text: Binding(
                            get: { background.feature.abilityDescription ?? "" },
                            set: { background.feature.abilityDescription = $0 }
                        ), axis: .vertical)
                        .lineLimit(3...6)
                    } else {
                        Text(background.feature.name)
                            .font(.headline)
                        Text(background.feature.abilityDescription ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
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
        }
        .navigationTitle(background.name)
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
