//
//  CharacterListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct CharacterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [Character]
    @Query private var classes: [DnDClass]
    @Query private var races: [Race]

    @State private var isShowingCreateSheet = false
    @State private var showingImportDialog = false
    @State private var importError: Error?
    @State private var showingImportError = false
    @State private var showingImportSuccess = false
    @State private var importedCharacterName = ""
    
    @State private var showingExportDialog = false
    @State private var characterToExport: Character?
    @State private var exportError: Error?
    @State private var showingExportError = false
    @State private var showingExportSuccess = false

    var body: some View {
        NavigationSplitView {
            characterList
        } detail: {
            Text("Sélectionnez un personnage")
                .foregroundColor(.gray)
        }
    }

    private var characterList: some View {
        List {
            ForEach(characters) { character in
                CharacterListRow(
                    character: character,
                    onDelete: { deleteCharacter(character) },
                    onExport: { exportCharacter(character) }
                )
            }
        }
        .navigationTitle("Personnages")
        .toolbar { listToolbar }
        .sheet(isPresented: $isShowingCreateSheet) {
            CharacterCreationView(availableClasses: classes, availableRaces: races) {
                isShowingCreateSheet = false
            }
        }
        .fileImporter(
            isPresented: $showingImportDialog,
            allowedContentTypes: [.json]
        ) { result in
            switch result {
            case .success(let url): importCharacter(from: url)
            case .failure(let error):
                importError = error
                showingImportError = true
            }
        }
        .fileExporter(
            isPresented: $showingExportDialog,
            document: makeCharacterDocument(),
            contentType: .json,
            defaultFilename: makeDefaultFilename()
        ) { result in
            handleExportResult(result)
        }
        .modifier(CharacterAlerts(
            showingImportError: $showingImportError,
            importError: importError,
            showingImportSuccess: $showingImportSuccess,
            importedCharacterName: importedCharacterName,
            showingExportError: $showingExportError,
            exportError: exportError,
            showingExportSuccess: $showingExportSuccess
        ))
    }

    @ToolbarContentBuilder
    private var listToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    isShowingCreateSheet = true
                } label: {
                    Label("Nouveau personnage", systemImage: "plus")
                }
                Divider()
                Button {
                    showingImportDialog = true
                } label: {
                    Label("Importer", systemImage: "square.and.arrow.down")
                }
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(characters[index])
            }
        }
    }
    
    private func deleteCharacter(_ character: Character) {
        withAnimation {
            modelContext.delete(character)
        }
    }
    
    private func exportCharacter(_ character: Character) {
        characterToExport = character
        showingExportDialog = true
    }
    
    private func importCharacter(from url: URL) {
        do {
            guard url.startAccessingSecurityScopedResource() else {
                throw CharacterImportExportError.invalidJSON
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            let importedCharacter = try CharacterImportExportService.importCharacter(from: url, context: modelContext)
            importedCharacterName = importedCharacter.name
            showingImportSuccess = true
        } catch {
            importError = error
            showingImportError = true
        }
    }

    private func makeCharacterDocument() -> CharacterDocument? {
        guard let character = characterToExport else { return nil }
        do {
            let data = try CharacterImportExportService.exportCharacter(character)
            return CharacterDocument(data: data)
        } catch {
            return nil
        }
    }
    
    private func makeDefaultFilename() -> String {
        return "\(characterToExport?.name ?? "personnage").json"
    }
    
    private func handleExportResult(_ result: Result<URL, Error>) {
        switch result {
        case .success:
            showingExportSuccess = true
        case .failure(let error):
            exportError = error
            showingExportError = true
        }
    }
}

// MARK: - Subviews

private struct CharacterListRow: View {
    let character: Character
    let onDelete: () -> Void
    let onExport: () -> Void

    var body: some View {
        NavigationLink {
            CharacterDetailView(character: character)
        } label: {
            CharacterRow(character: character)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Supprimer", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button(action: onExport) {
                Label("Exporter", systemImage: "square.and.arrow.up")
            }
            .tint(.blue)
        }
    }
}

private struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character.name)
                .font(.headline)
            HStack {
                if let dndClass = character.dndClass {
                    Text(dndClass.name)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                if let race = character.race {
                    Text("• \(race.name)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Niv. \(character.level)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct CharacterAlerts: ViewModifier {
    @Binding var showingImportError: Bool
    let importError: Error?
    @Binding var showingImportSuccess: Bool
    let importedCharacterName: String
    @Binding var showingExportError: Bool
    let exportError: Error?
    @Binding var showingExportSuccess: Bool

    func body(content: Content) -> some View {
        content
            .alert("Erreur d'import", isPresented: $showingImportError) {
                Button("OK", role: .cancel) { }
            } message: {
                let message = importError?.localizedDescription ?? "Une erreur est survenue lors de l'import"
                Text(message)
            }
            .alert("Import réussi", isPresented: $showingImportSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Le personnage '\(importedCharacterName)' a été importé avec succès")
            }
            .alert("Erreur d'export", isPresented: $showingExportError) {
                Button("OK", role: .cancel) { }
            } message: {
                let message = exportError?.localizedDescription ?? "Une erreur est survenue lors de l'export"
                Text(message)
            }
            .alert("Export réussi", isPresented: $showingExportSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Le personnage a été exporté avec succès")
            }
    }
}
