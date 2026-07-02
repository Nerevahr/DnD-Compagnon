//
//  SpellFilterView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


//
//  SpellFilterView.swift
//  DnDCompagnon
//

import SwiftUI

struct SpellFilterView: View {
    @Binding var viewModel: SpellListViewModel

    private let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Niveau")) {
                    ForEach(0...9, id: \.self) { niveau in
                        filterRow(
                            label: niveau == 0 ? "Tour de magie" : "Niveau \(niveau)",
                            isSelected: viewModel.filterNiveaux.contains(niveau)
                        ) {
                            viewModel.filterNiveaux.formSymmetricDifference([niveau])
                        }
                    }
                }

                Section(header: Text("Classes")) {
                    ForEach(Spell.classesDnD, id: \.self) { classe in
                        filterRow(
                            label: classe,
                            isSelected: viewModel.filterClasses.contains(classe)
                        ) {
                            viewModel.filterClasses.formSymmetricDifference([classe])
                        }
                    }
                }

                Section(header: Text("École de magie")) {
                    ForEach(ecolesDeMagie, id: \.self) { ecole in
                        filterRow(
                            label: ecole,
                            isSelected: viewModel.filterEcoles.contains(ecole)
                        ) {
                            viewModel.filterEcoles.formSymmetricDifference([ecole])
                        }
                    }
                }

                Section(header: Text("Concentration")) {
                    ForEach(
                        [("Tous", nil as Bool?), ("Avec concentration", true), ("Sans concentration", false)],
                        id: \.0
                    ) { label, value in
                        filterRow(
                            label: label,
                            isSelected: viewModel.filterConcentration == value
                        ) {
                            viewModel.filterConcentration = value
                        }
                    }
                }
            }
            .navigationTitle("Filtres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { viewModel.isShowingFilterSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Réinitialiser") { viewModel.resetFilters() }
                        .disabled(!viewModel.hasActiveFilters)
                }
            }
        }
    }

    private func filterRow(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            Text(label)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark").foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}