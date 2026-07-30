//
//  SpellSheetListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import SwiftUI
import SwiftData

struct SpellSheetListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpellSheet.timestamp, order: .reverse) private var spellSheets: [SpellSheet]

    @State private var isShowingCreateSheet = false

    var body: some View {
        NavigationSplitView {
            spellSheetList
        } detail: {
            Text("Sélectionnez une fiche de sorts")
                .foregroundColor(.gray)
        }
    }

    private var spellSheetList: some View {
        List {
            ForEach(spellSheets) { spellSheet in
                SpellSheetListRow(
                    spellSheet: spellSheet,
                    onDelete: { deleteSpellSheet(spellSheet) }
                )
            }
        }
        .navigationTitle("Fiche de sorts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .overlay {
            if spellSheets.isEmpty {
                ContentUnavailableView(
                    "Aucune fiche de sorts",
                    systemImage: "list.bullet.rectangle.portrait",
                    description: Text("Appuyez sur + pour créer une fiche de sorts.")
                )
            }
        }
        .sheet(isPresented: $isShowingCreateSheet) {
            SpellSheetCreationView {
                isShowingCreateSheet = false
            }
        }
    }

    private func deleteSpellSheet(_ spellSheet: SpellSheet) {
        withAnimation {
            modelContext.delete(spellSheet)
        }
    }
}

// MARK: - Subviews

private struct SpellSheetListRow: View {
    let spellSheet: SpellSheet
    let onDelete: () -> Void

    var body: some View {
        NavigationLink {
            SpellSheetDetailView(spellSheet: spellSheet)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(spellSheet.title)
                    .font(.headline)
                Text(spellCountText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }

    private var spellCountText: String {
        let count = spellSheet.preparedSpells.count
        return count > 1 ? "\(count) sorts" : "\(count) sort"
    }
}
