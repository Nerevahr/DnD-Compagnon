//
//  SpellDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//


//
//  SpellDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

struct SpellDetailView: View {
    @Bindable var spell: Spell
    
    @State private var isEditing = false
    @State private var editingClasses: Set<String> = []
    
    let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if isEditing {
                    editingView
                } else {
                    readingView
                }
            }
            .padding()
        }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        if isEditing {
                            // Valider les modifications
                            spell.classes = Array(editingClasses).sorted()
                            if !spell.componentM {
                                spell.materialDescription = ""
                            }
                        } else {
                            // Entrer en édition : initialiser l'état local
                            editingClasses = Set(spell.classes)
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
    }
    
    // MARK: - Mode Lecture
    
    private var readingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Niveau et école
            HStack {
                Text(spell.niveauLabel)
                    .font(.headline)
                    .foregroundColor(.purple)
                Spacer()
                Text(spell.ecole)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            // Infos rapides
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Temps d'incantation", value: spell.dureeIncantation)
                InfoRow(label: "Portée", value: spell.portee)
                InfoRow(label: "Composantes", value: spell.formattedComponents)
                if spell.componentM && !spell.materialDescription.isEmpty {
                    InfoRow(label: "Matériel", value: spell.materialDescription)
                }
                InfoRow(label: "Durée", value: spell.duree)
                if spell.concentration {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.orange)
                        Text("Concentration")
                            .foregroundColor(.orange)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Description
            if !spell.descriptionSort.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(spell.descriptionSort)
                        .font(.body)
                }
            }
            
            // Classes
            if !spell.classes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Classes")
                        .font(.headline)
                    Text(spell.classesLabel)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Mode Édition
    
    private var editingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Nom
            VStack(alignment: .leading, spacing: 8) {
                Text("Nom du sort")
                    .font(.headline)
                TextField("Nom", text: $spell.name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Niveau et école
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Niveau")
                        .font(.headline)
                    Picker("Niveau", selection: $spell.niveau) {
                        Text("Tour de magie").tag(0)
                        ForEach(1...9, id: \.self) { n in
                            Text("Niveau \(n)").tag(n)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("École")
                        .font(.headline)
                    Picker("École", selection: $spell.ecole) {
                        ForEach(ecolesDeMagie, id: \.self) { ecole in
                            Text(ecole).tag(ecole)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            // Caractéristiques
            VStack(alignment: .leading, spacing: 8) {
                Text("Caractéristiques")
                    .font(.headline)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Portée")
                            .frame(width: 120, alignment: .leading)
                        TextField("Portée", text: $spell.portee)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Incantation")
                            .frame(width: 120, alignment: .leading)
                        TextField("Temps d'incantation", text: $spell.dureeIncantation)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Durée")
                            .frame(width: 120, alignment: .leading)
                        TextField("Durée", text: $spell.duree)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Toggle("Concentration", isOn: $spell.concentration)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Composantes
            VStack(alignment: .leading, spacing: 8) {
                Text("Composantes")
                    .font(.headline)
                
                VStack(spacing: 8) {
                    Toggle("Verbal (V)", isOn: $spell.componentV)
                    Toggle("Somatique (S)", isOn: $spell.componentS)
                    Toggle("Matériel (M)", isOn: $spell.componentM)
                    
                    if spell.componentM {
                        TextField("Spécifiez le matériel", text: $spell.materialDescription)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Classes
            VStack(alignment: .leading, spacing: 8) {
                Text("Classes")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Spell.classesDnD, id: \.self) { classe in
                            Button(action: {
                                if editingClasses.contains(classe) {
                                    editingClasses.remove(classe)
                                } else {
                                    editingClasses.insert(classe)
                                }
                            }) {
                                Text(classe)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(editingClasses.contains(classe) ? Color.accentColor : Color.gray.opacity(0.2))
                                    .foregroundColor(editingClasses.contains(classe) ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.headline)
                TextEditor(text: $spell.descriptionSort)
                    .frame(minHeight: 120)
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
}