//
//  CharacterDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct CharacterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var classes: [DnDClass]
    
    @Bindable var character: Character

    @State private var isShowingEditSheet = false
    @State private var currentPage = 0
    @State private var showingExportDialog = false
    @State private var exportError: Error?
    @State private var showingExportError = false
    @State private var exportData: Data?
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec infos du personnage
            CharacterHeader(character: character)
            
            // Indicateur de page
            HStack(spacing: 8) {
                PageIndicator(title: "Caractéristiques", isActive: currentPage == 0)
                PageIndicator(title: "Combat", isActive: currentPage == 1)
                PageIndicator(title: "Sorts", isActive: currentPage == 2)
                PageIndicator(title: "Inventaire", isActive: currentPage == 3)
            }
            .padding(.vertical, 8)
            
            // TabView avec pages scrollables
            TabView(selection: $currentPage) {
                StatsAndSkillsPage(character: character)
                    .tag(0)
                
                CombatPage(character: character)
                    .tag(1)
                
                SpellsPage(character: character)
                    .tag(2)
                
                InventoryPage(character: character)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Éditer") {
                        isShowingEditSheet = true
                    }
                    
                    Divider()
                    
                    Button {
                        exportCharacter()
                    } label: {
                        Label("Exporter", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            CharacterEditView(character: character, availableClasses: classes)
        }
        .fileExporter(
            isPresented: $showingExportDialog,
            document: exportData.map { CharacterDocument(data: $0) },
            contentType: .json,
            defaultFilename: "\(character.name).json"
        ) { result in
            switch result {
            case .success(let url):
                print("Personnage exporté vers: \(url)")
            case .failure(let error):
                exportError = error
                showingExportError = true
            }
        }
        .alert("Erreur d'export", isPresented: $showingExportError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(exportError?.localizedDescription ?? "Une erreur est survenue lors de l'export")
        }
    }
    
    private func exportCharacter() {
        do {
            exportData = try CharacterImportExportService.exportCharacter(character)
            showingExportDialog = true
        } catch {
            exportError = error
            showingExportError = true
        }
    }
}

#Preview("Guerrier") {
    CharacterDetailView(character: MockData.fighter)
}
