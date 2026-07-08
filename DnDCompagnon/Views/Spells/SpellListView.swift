//
//  SpellListView.swift
//  DnDCompagnon
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SpellListView: View {
    var resourceSelector: AnyView? = nil

    @Environment(\.modelContext) private var modelContext
    @Query private var spells: [Spell]
    @State private var viewModel = SpellListViewModel()
    @State private var isShowingImportPicker = false

    private var groupedSpells: [Int: [Spell]] {
        viewModel.filteredAndGrouped(spells)
    }

    private var sortedLevels: [Int] {
        groupedSpells.keys.sorted()
    }

    var body: some View {
        List {
            ForEach(sortedLevels, id: \.self) { niveau in
                SpellLevelSection(
                    level: niveau,
                    spells: groupedSpells[niveau] ?? [],
                    onDelete: { indexSet in
                        let spellsInSection = groupedSpells[niveau] ?? []
                        let toDelete = indexSet.map { spellsInSection[$0] }
                        viewModel.deleteSpells(toDelete, context: modelContext)
                    }
                )
            }
        }
        .navigationTitle("Sorts")
        .toolbar {
            SpellListToolbar(
                viewModel: $viewModel,
                isShowingImportPicker: $isShowingImportPicker,
                resourceSelector: resourceSelector
            )
        }
        .sheet(isPresented: $viewModel.isShowingFilterSheet) {
            SpellFilterView(viewModel: $viewModel)
        }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
            AddSpellView(viewModel: $viewModel) {
                viewModel.addSpell(context: modelContext)
                viewModel.isShowingAddSheet = false
            }
        }
        .fileImporter(
            isPresented: $isShowingImportPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                Task {
                    await viewModel.importSpells(from: url, context: modelContext)
                }
            }
        }
        .alert("Importation réussie", isPresented: $viewModel.showImportSuccess) {
            Button("OK") { }
        } message: {
            Text("\(viewModel.importSuccessCount) sort(s) importé(s) avec succès")
        }
        .alert("Erreur d'importation", isPresented: $viewModel.showImportError) {
            Button("OK") { }
        } message: {
            Text(viewModel.importErrorMessage ?? "Erreur inconnue")
        }
        .overlay {
            if viewModel.isImporting {
                ImportingOverlayView()
            }
        }
    }
}
