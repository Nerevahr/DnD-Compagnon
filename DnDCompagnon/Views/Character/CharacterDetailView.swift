//
//  CharacterDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterDetailView: View {
    @State private var viewModel: CharacterDetailViewModel
    @Bindable var character: Character

    init(character: Character) {
        self.character = character
        _viewModel = State(initialValue: CharacterDetailViewModel(character: character))
        
        // Valider l'intégrité du personnage au chargement
        if let error = character.validateIntegrity() {
            print("⚠️  CHARACTER LOAD ERROR: \(error)")
            character.printDiagnostics()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec infos du personnage
            CharacterHeader(character: character)
            
            // Indicateur de page
            HStack(spacing: 8) {
                PageIndicator(title: "Caractéristiques", isActive: viewModel.currentPage == 0) {
                    viewModel.currentPage = 0
                }
                PageIndicator(title: "Combat", isActive: viewModel.currentPage == 1) {
                    viewModel.currentPage = 1
                }
                PageIndicator(title: "Sorts", isActive: viewModel.currentPage == 2) {
                    viewModel.currentPage = 2
                }
                PageIndicator(title: "Aptitudes", isActive: viewModel.currentPage == 3) {
                    viewModel.currentPage = 3
                }
                PageIndicator(title: "Inventaire", isActive: viewModel.currentPage == 4) {
                    viewModel.currentPage = 4
                }
            }
            .padding(.vertical, 8)
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

            
            // TabView avec pages scrollables
            TabView(selection: $viewModel.currentPage) {
                StatsAndSkillsPage(character: character)
                    .tag(0)
                
                CombatPage(character: character)
                    .tag(1)
                
                SpellsPage(character: character)
                    .tag(2)
                
                AbilitiesPage(character: character)
                    .tag(3)
                
                InventoryPage(character: character)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Éditer") {
                    viewModel.isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingEditSheet) {
            CharacterEditView(character: character)
        }
    }
}

#Preview("Guerrier") {
    CharacterDetailView(character: MockData.fighter)
}
