//
//  SkillBonusEditSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI

/// Feuille pour éditer le bonus personnalisé d'une compétence
struct SkillBonusEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    let skill: DnDSkill
    let character: Character
    @Binding var bonusMode: SkillBonusMode
    let onApplyFixed: (Int) -> Void
    let onApplyStat: (String) -> Void
    let onClear: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Compétence") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.headline)
                            Text(skill.baseStat)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                
                Section("Type de bonus") {
                    Picker("Mode", selection: $bonusMode) {
                        Text("Aucun").tag(SkillBonusMode.none)
                        Text("Valeur fixe").tag(SkillBonusMode.fixed(0))
                        Text("Caractéristique").tag(SkillBonusMode.stat("Force"))
                    }
                }
                
                // Section pour le bonus fixe
                if case .fixed(let value) = bonusMode {
                    Section("Valeur du bonus") {
                        Stepper("Bonus: \(value)", value: Binding(
                            get: { value },
                            set: { newValue in
                                bonusMode = .fixed(newValue)
                            }
                        ), in: -10...10)
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            onClear()
                            dismiss()
                        } label: {
                            Label("Supprimer le bonus", systemImage: "trash")
                        }
                    }
                }
                
                // Section pour le bonus stat
                if case .stat(let stat) = bonusMode {
                    Section("Caractéristique à ajouter") {
                        Picker("Stat", selection: Binding(
                            get: { stat },
                            set: { newStat in
                                bonusMode = .stat(newStat)
                            }
                        )) {
                            ForEach(Character.abilityScores, id: \.self) { ability in
                                Text(ability).tag(ability)
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Bonus ajouté")
                            Spacer()
                            let modifier = character.getModifier(for: stat)
                            Text("\(modifier >= 0 ? "+" : "")\(modifier)")
                                .fontWeight(.semibold)
                                .foregroundColor(modifier >= 0 ? .green : .red)
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            onClear()
                            dismiss()
                        } label: {
                            Label("Supprimer le bonus", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Bonus de \(skill.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Appliquer") {
                        switch bonusMode {
                        case .none:
                            break
                        case .fixed(let value):
                            onApplyFixed(value)
                        case .stat(let stat):
                            onApplyStat(stat)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}
