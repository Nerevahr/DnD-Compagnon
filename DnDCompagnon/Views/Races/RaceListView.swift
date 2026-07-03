//
//  RaceListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// Views/Races/RaceListView.swift
import SwiftUI
import SwiftData

struct RaceListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Race.name) private var races: [Race]
    @State private var viewModel = RaceListViewModel()
    @State private var showingAddRace = false

    let resourceSelector: AnyView

    var body: some View {
        List {
            ForEach(viewModel.filtered(races)) { race in
                NavigationLink(destination: RaceDetailView(race: race)) {
                    RaceRowView(race: race)
                }
            }
            .onDelete(perform: deleteRaces)
        }
        .navigationTitle("Races")
        .searchable(text: $viewModel.searchText, prompt: "Rechercher une race")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                resourceSelector
            }
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddRace = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddRace) {
            AddRaceView()
        }
    }

    private func deleteRaces(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(viewModel.filtered(races)[index])
        }
    }
}

// MARK: - Sous-vue ligne
private struct RaceRowView: View {
    let race: Race

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(race.name)
                .font(.headline)
            HStack(spacing: 8) {
                if let speed = race.speed {
                    Label("\(speed) pieds", systemImage: "figure.walk")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(race.defaultSize)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}