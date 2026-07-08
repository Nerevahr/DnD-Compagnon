//
//  SpellListToolbar.swift
//  DnDCompagnon
//

import SwiftUI

struct SpellListToolbar: ToolbarContent {
    @Binding var viewModel: SpellListViewModel
    @Binding var isShowingImportPicker: Bool
    var resourceSelector: AnyView?

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let selector = resourceSelector { selector }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            filterButton
        }
        ToolbarItem {
            addMenu
        }
    }

    // MARK: - Subcomponents

    private var filterButton: some View {
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

    private var addMenu: some View {
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
