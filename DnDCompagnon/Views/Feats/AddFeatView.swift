//
//  AddFeatView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI

struct AddFeatView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: FeatListViewModel
    let onAdd: () -> Void
    
    var isFormValid: Bool {
        !viewModel.newFeatName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !viewModel.newFeatDescription.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations du don") {
                    TextField("Nom du don", text: $viewModel.newFeatName)
                    
                    Picker("Type", selection: $viewModel.newFeatType) {
                        ForEach(FeatType.allCases, id: \.self) { type in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(type.color)
                                    .frame(width: 8, height: 8)
                                Text(type.displayName)
                            }
                            .tag(type)
                        }
                    }
                }
                
                Section("Description") {
                    TextEditor(text: $viewModel.newFeatDescription)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Ajouter un don")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        viewModel.resetForm()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        onAdd()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    AddFeatView(
        viewModel: .init(),
        onAdd: { }
    )
}
