//
//  ResourceType.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI

enum ResourceType: String, CaseIterable {
    case spells = "Sorts"
    case items = "Objets"
    case classes = "Classes"  // ← Nouveau
}

struct ResourcesView: View {
    @State private var selectedResource: ResourceType = .spells
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch selectedResource {
                case .spells:
                    SpellListView(resourceSelector: AnyView(resourceSelectorView))
                case .items:
                    ItemListView(resourceSelector: AnyView(resourceSelectorView))
                case .classes:
                    ClassListView(resourceSelector: AnyView(resourceSelectorView))
                }
            }
        }
        .onChange(of: selectedResource) { _, _ in
            // Réinitialiser le chemin de navigation lors du changement
            navigationPath = NavigationPath()
        }
    }
    
    private var resourceSelectorView: some View {
        Menu {
            ForEach(ResourceType.allCases, id: \.self) { type in
                Button {
                    selectedResource = type
                } label: {
                    HStack {
                        Text(type.rawValue)
                        if selectedResource == type {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedResource.rawValue)
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }
}
