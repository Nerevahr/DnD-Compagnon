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
                Section(header: Text(viewModel.niveauSectionHeader(niveau))) {
                    ForEach(groupedSpells[niveau] ?? []) { spell in
                        NavigationLink {
                            SpellDetailView(spell: spell)
                        } label: {
                            SpellRow(spell: spell)
                        }
                    }
                    .onDelete { indexSet in
                        let spellsInSection = groupedSpells[niveau] ?? []
                        let toDelete = indexSet.map { spellsInSection[$0] }
                        viewModel.deleteSpells(toDelete, context: modelContext)
                    }
                }
            }
        }
        .navigationTitle("Sorts")
        .toolbar { toolbar }
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
                importingOverlay
            }
        }
    }

    // MARK: - Subviews

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let selector = resourceSelector { selector }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { viewModel.isShowingFilterSheet = true } label: {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.hasActiveFilters
                        ? "line.3.horizontal.decrease.circle.fill"
                        : "line.3.horizontal.decrease.circle")
                    if viewModel.hasActiveFilters {
                        Text("\(viewModel.activeFilterCount)")
                            .font(.caption2).fontWeight(.bold)
                    }
                }
            }
        }
        ToolbarItem {
            Menu {
                Button { viewModel.isShowingAddSheet = true } label: {
                    Label("Ajouter manuellement", systemImage: "plus")
                }
                Button { isShowingImportPicker = true } label: {
                    Label("Importer depuis JSON", systemImage: "arrow.down.doc")
                }
            } label: {
                Label("Ajouter", systemImage: "plus")
            }
        }
    }

    private var importingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView("Importation en cours...")
                .padding()
                .background(.background)
                .cornerRadius(10)
        }
    }
}

// MARK: - SpellRow

private struct SpellRow: View {
    let spell: Spell

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(spell.name).font(.headline)
                Spacer()
                if spell.concentration {
                    Image(systemName: "c.circle.fill")
                        .foregroundColor(.orange)
                        .help("Concentration")
                }
            }
            HStack {
                Text("• \(spell.portee)").font(.subheadline).foregroundColor(.gray)
                Text("• \(spell.formattedComponents)").font(.subheadline).foregroundColor(.gray)
            }
        }
    }
}
