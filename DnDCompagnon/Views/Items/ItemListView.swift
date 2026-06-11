//
//  ItemListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//


import SwiftUI
import SwiftData
import PhotosUI

struct ItemListView: View {
    var resourceSelector: AnyView? = nil

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var isShowingAddSheet = false
    @State private var newItemName = ""
    @State private var newItemDescription = ""
    @State private var newItemType: ItemType = .objet
    @State private var newItemImageData: Data? = nil
    @State private var isShowingImagePicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    // Grouper les objets par type
    private var groupedItems: [ItemType: [Item]] {
        Dictionary(grouping: items, by: { $0.type })
    }
    
    private var sortedTypes: [ItemType] {
        groupedItems.keys.sorted { ItemType.allValues.firstIndex(of: $0.rawValue)! < ItemType.allValues.firstIndex(of: $1.rawValue)! }
    }
    
    var body: some View {
            List {
                ForEach(sortedTypes, id: \.self) { type in
                    Section(header: Text(type.rawValue)) {
                        ForEach(groupedItems[type] ?? []) { item in
                            NavigationLink {
                                ItemDetailView(item: item)
                            } label: {
                                HStack(spacing: 12) {
                                    if let imageData = item.imageData,
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(4)
                                    } else {
                                        Image(systemName: "cube.fill")
                                            .font(.title3)
                                            .foregroundColor(.gray)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.itemDescription)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteItems(at: indexSet, of: type)
                        }
                    }
                }
            }
            .navigationTitle("Objets")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        if let selector = resourceSelector {
                            selector
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddSheet = true }) {
                        Label("Ajouter un objet", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Détails de l'Objet")) {
                            TextField("Nom", text: $newItemName)
                            Picker("Type", selection: $newItemType) {
                                ForEach(ItemType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                        }
                        
                        Section(header: Text("Description")) {
                            TextEditor(text: $newItemDescription)
                                .frame(minHeight: 100)
                        }
                        
                        Section(header: Text("Image")) {
                            PhotosPicker(selection: $selectedPhotoItem,
                                        matching: .images,
                                        photoLibrary: .shared()) {
                                HStack {
                                    if let imageData = newItemImageData,
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(4)
                                    } else {
                                        Label("Sélectionner une image", systemImage: "photo")
                                    }
                                }
                            }
                            .onChange(of: selectedPhotoItem) { _, newValue in
                                if let newValue {
                                    Task {
                                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                                            newItemImageData = data
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Nouvel Objet")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                isShowingAddSheet = false
                                resetForm()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Ajouter") {
                                addItem()
                                isShowingAddSheet = false
                                resetForm()
                            }
                            .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
    
    }
    
    private func addItem() {
        let newItem = Item(
            timestamp: Date(),
            name: newItemName,
            itemDescription: newItemDescription,
            type: newItemType,
            imageData: newItemImageData
        )
        modelContext.insert(newItem)
    }
    
    private func deleteItems(at offsets: IndexSet, of type: ItemType) {
        withAnimation {
            let itemsOfType = groupedItems[type] ?? []
            for index in offsets {
                modelContext.delete(itemsOfType[index])
            }
        }
    }
    
    private func resetForm() {
        newItemName = ""
        newItemDescription = ""
        newItemType = .objet
        newItemImageData = nil
        selectedPhotoItem = nil
    }
}

// MARK: - Vue de Détail
struct ItemDetailView: View {
    @Bindable var item: Item
    @State private var isEditing = false
    @State private var editingImageData: Data? = nil
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    var body: some View {
        Form {
            Section(header: Text("Détails")) {
                if isEditing {
                    TextField("Nom", text: $item.name)
                    Picker("Type", selection: $item.type) {
                        ForEach(ItemType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                } else {
                    LabeledContent("Nom", value: item.name)
                    LabeledContent("Type", value: item.type.rawValue)
                }
            }
            
            Section(header: Text("Description")) {
                if isEditing {
                    TextEditor(text: $item.itemDescription)
                        .frame(minHeight: 100)
                } else {
                    if item.itemDescription.isEmpty {
                        Text("Aucune description")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Text(item.itemDescription)
                    }
                }
            }
            
            Section(header: Text("Image")) {
                if isEditing {
                    PhotosPicker(selection: $selectedPhotoItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                        if let imageData = editingImageData ?? item.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(4)
                        } else {
                            Label("Sélectionner une image", systemImage: "photo")
                        }
                    }
                    .onChange(of: selectedPhotoItem) { _, newValue in
                        if let newValue {
                            Task {
                                if let data = try? await newValue.loadTransferable(type: Data.self) {
                                    editingImageData = data
                                }
                            }
                        }
                    }
                } else {
                    if let imageData = item.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(4)
                    } else {
                        Text("Aucune image")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        if isEditing {
                            if let editingImageData {
                                item.imageData = editingImageData
                            }
                        } else {
                            editingImageData = item.imageData
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}
