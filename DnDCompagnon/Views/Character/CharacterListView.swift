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

    @State private var isShowingCreateSheet = false
    @State private var showingImportDialog = false
    @State private var importError: Error?
    @State private var showingImportError = false
    @State private var showingImportSuccess = false
    @State private var importedCharacterName = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(characters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(character.name)
                                .font(.headline)
                            HStack {
                                if let dndClass = character.dndClass {
                                    Text(dndClass.name)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                if !character.race.isEmpty {
                                    Text("• \(character.race)")
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
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Personnages")
            .toolbar {
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
            .sheet(isPresented: $isShowingCreateSheet) {
                CharacterCreationView(availableClasses: classes) {
                    isShowingCreateSheet = false
                }
            }
            .fileImporter(
                isPresented: $showingImportDialog,
                allowedContentTypes: [.json]
            ) { result in
                switch result {
                case .success(let url):
                    importCharacter(from: url)
                case .failure(let error):
                    importError = error
                    showingImportError = true
                }
            }
            .alert("Erreur d'import", isPresented: $showingImportError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(importError?.localizedDescription ?? "Une erreur est survenue lors de l'import")
            }
            .alert("Import réussi", isPresented: $showingImportSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Le personnage '\(importedCharacterName)' a été importé avec succès")
            }
        } detail: {
            Text("Sélectionnez un personnage")
                .foregroundColor(.gray)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(characters[index])
            }
        }
    }
    
    private func importCharacter(from url: URL) {
        do {
            // Accéder au fichier avec sécurité
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
}
