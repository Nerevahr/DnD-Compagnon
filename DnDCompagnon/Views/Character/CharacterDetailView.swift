//
//  CharacterDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import SwiftData

struct CharacterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var classes: [DnDClass]
    
    @Bindable var character: Character

    @State private var isShowingEditSheet = false
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec infos du personnage
            CharacterHeader(character: character)
            
            // Indicateur de page
            HStack(spacing: 8) {
                PageIndicator(title: "Caractéristiques", isActive: currentPage == 0)
                PageIndicator(title: "Sorts", isActive: currentPage == 1)
                PageIndicator(title: "Inventaire", isActive: currentPage == 2)
            }
            .padding(.vertical, 8)
            
            // TabView avec pages scrollables
            TabView(selection: $currentPage) {
                StatsAndSkillsPage(character: character)
                    .tag(0)
                
                SpellsPage(character: character)
                    .tag(1)
                
                InventoryPage(character: character)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Éditer") {
                    isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            CharacterEditView(character: character, availableClasses: classes)
        }
    }
}
