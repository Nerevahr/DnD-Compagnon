//
//  AddSpellView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


//
//  AddSpellView.swift
//  DnDCompagnon
//

import SwiftUI

struct AddSpellView: View {
    @Binding var viewModel: SpellListViewModel
    let onAdd: () -> Void

    private let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du Sort")) {
                    TextField("Nom du sort", text: $viewModel.newSpellName)

                    Picker("École de magie", selection: $viewModel.newSpellEcole) {
                        ForEach(ecolesDeMagie, id: \.self) { Text($0).tag($0) }
                    }

                    Picker("Niveau", selection: $viewModel.newSpellNiveau) {
                        Text("Tour de magie").tag(0)
                        ForEach(1...9, id: \.self) { Text("Niveau \($0)").tag($0) }
                    }
                }

                Section(header: Text("Paramètres")) {
                    TextField("Portée", text: $viewModel.newSpellPortee)
                    TextField("Durée d'incantation", text: $viewModel.newSpellDuree)
                    TextField("Durée de l'effet", text: $viewModel.newSpellDureeSortComplete)
                    Toggle("Concentration", isOn: $viewModel.newSpellConcentration)
                }

                Section(header: Text("Composantes")) {
                    Toggle("Verbal (V)", isOn: $viewModel.newSpellV)
                    Toggle("Somatique (S)", isOn: $viewModel.newSpellS)
                    Toggle("Matériel (M)", isOn: $viewModel.newSpellM)
                    if viewModel.newSpellM {
                        TextField("Spécifiez le matériel (ex: une plume)", text: $viewModel.newSpellMaterialDescription)
                            .transition(.opacity)
                    }
                }

                Section(header: Text("Classes")) {
                    ForEach(Spell.classesDnD, id: \.self) { classe in
                        HStack {
                            Text(classe)
                            Spacer()
                            if viewModel.newSpellClasses.contains(classe) {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.newSpellClasses.contains(classe) {
                                viewModel.newSpellClasses.remove(classe)
                            } else {
                                viewModel.newSpellClasses.insert(classe)
                            }
                        }
                    }
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $viewModel.newSpellDescription)
                        .frame(minHeight: 120)
                }
            }
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