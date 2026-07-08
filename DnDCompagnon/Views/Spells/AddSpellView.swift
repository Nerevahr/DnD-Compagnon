//
//  AddSpellView.swift
//  DnDCompagnon
//

import SwiftUI

struct AddSpellView: View {
    @Binding var viewModel: SpellListViewModel
    let onAdd: () -> Void

    var body: some View {
        NavigationStack {
            AddSpellForm(viewModel: $viewModel)
                .navigationTitle("Nouveau Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        viewModel.isShowingAddSheet = false
                        viewModel.resetForm()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") { onAdd() }
                        .disabled(viewModel.newSpellName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
