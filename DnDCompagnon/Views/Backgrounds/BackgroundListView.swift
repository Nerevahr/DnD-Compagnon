//
//  BackgroundListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Backgrounds/BackgroundListView.swift
import SwiftUI
import SwiftData

struct BackgroundListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Background.name) private var backgrounds: [Background]
    @State private var viewModel = BackgroundListViewModel()
    @State private var showingAddBackground = false

    let resourceSelector: AnyView

    var body: some View {
        List {
            ForEach(viewModel.filtered(backgrounds)) { background in
                NavigationLink(destination: BackgroundDetailView(background: background)) {
                    BackgroundRowView(background: background)
                }
            }
            .onDelete(perform: deleteBackgrounds)
        }
        .navigationTitle("Origines")
        .searchable(text: $viewModel.searchText, prompt: "Rechercher une origine")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                resourceSelector
            }
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddBackground = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddBackground) {
            AddBackgroundView()
        }
    }

    private func deleteBackgrounds(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(viewModel.filtered(backgrounds)[index])
        }
    }
}

// MARK: - Sous-vue ligne
private struct BackgroundRowView: View {
    let background: Background

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(background.name)
                .font(.headline)
            Text(background.feature.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}