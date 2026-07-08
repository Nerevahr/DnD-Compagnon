//
//  FeatListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI
import SwiftData

struct FeatListView: View {
    var resourceSelector: AnyView? = nil
    
    @Environment(\.modelContext) private var modelContext
    @Query private var feats: [Feat]
    @State private var viewModel = FeatListViewModel()
    
    private var groupedFeats: [FeatType: [Feat]] {
        viewModel.groupedAndSorted(feats)
    }
    
    private var sortedTypes: [FeatType] {
        viewModel.featTypesWithFeats(feats)
    }
    
    var body: some View {
        List {
            if feats.isEmpty {
                ContentUnavailableView(
                    "Aucun don",
                    systemImage: "sparkles",
                    description: Text("Cliquez sur + pour ajouter un don")
                )
            } else {
                ForEach(sortedTypes, id: \.self) { type in
                    Section(header: HStack {
                        Circle()
                            .fill(type.color)
                            .frame(width: 12, height: 12)
                        Text(type.displayName)
                    }) {
                        FeatSectionContent(
                            feats: groupedFeats[type] ?? [],
                            viewModel: viewModel,
                            modelContext: modelContext
                        )
                    }
                }
            }
        }
        .navigationTitle("Dons")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let resourceSelector = resourceSelector {
                    resourceSelector
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { viewModel.isShowingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
            AddFeatView(viewModel: viewModel) {
                viewModel.addFeat(context: modelContext)
                viewModel.isShowingAddSheet = false
            }
        }
    }
}

// MARK: - Section Content

private struct FeatSectionContent: View {
    let feats: [Feat]
    let viewModel: FeatListViewModel
    let modelContext: ModelContext
    
    var body: some View {
        ForEach(feats, id: \.id) { feat in
            NavigationLink(destination: FeatDetailView(feat: feat)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(feat.name)
                        .font(.body)
                        .fontWeight(.semibold)
                    Text(feat.featDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .onDelete { indexSet in
            let toDelete = indexSet.map { feats[$0] }
            viewModel.deleteFeats(toDelete, context: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        FeatListView()
            .modelContainer(PreviewHelper.container)
    }
}

private struct PreviewHelper {
    static let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Feat.self, configurations: config)
        
        // Ajouter quelques dons d'exemple
        let exampleFeats = [
            Feat(name: "Alerte", type: .general, featDescription: "Vous gagnez +5 à l'initiative."),
            Feat(name: "Costaud", type: .origine, featDescription: "Augmentez votre score de Force de 1."),
            Feat(name: "Attaque défensive", type: .styleDeCombat, featDescription: "Vous pouvez sacrifier de l'attaque pour de la défense.")
        ]
        
        for feat in exampleFeats {
            container.mainContext.insert(feat)
        }
        
        return container
    }()
}
