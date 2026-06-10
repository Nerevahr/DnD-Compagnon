//
//  SpellListView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 10/06/2026.
//

import SwiftUI
import SwiftData

struct SpellListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var spells: [Spell]

    @State private var isShowingAddSheet = false
    
    // Formulaire d'ajout
    @State private var newSpellName = ""
    @State private var newSpellPortee = ""
    @State private var newSpellEcole = "Évocation"
    @State private var newSpellV = false
    @State private var newSpellS = false
    @State private var newSpellM = false
    @State private var newSpellMaterialDescription = ""
    @State private var newSpellDuree = ""

    let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(spells) { spell in
                    NavigationLink {
                        // ⚠️ Redirection vers la vue de détail gérant le mode lecture / édition
                        SpellDetailView(spell: spell)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(spell.name)
                                .font(.headline)
                            HStack {
                                Text(spell.ecole)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.purple.opacity(0.15))
                                    .foregroundColor(.purple)
                                    .cornerRadius(4)
                                
                                Text("• \(spell.portee)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSpells)
            }
            .navigationTitle("Sorts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowingAddSheet = true }) {
                        Label("Ajouter un sort", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Détails du Sort")) {
                            TextField("Nom du sort", text: $newSpellName)
                            
                            Picker("École de magie", selection: $newSpellEcole) {
                                ForEach(ecolesDeMagie, id: \.self) { ecole in
                                    Text(ecole).tag(ecole)
                                }
                            }
                        }
                        
                        Section(header: Text("Paramètres")) {
                            TextField("Portée", text: $newSpellPortee)
                            TextField("Durée d'incantation", text: $newSpellDuree)
                        }
                        
                        Section(header: Text("Composantes")) {
                            Toggle("Verbal (V)", isOn: $newSpellV)
                            Toggle("Somatique (S)", isOn: $newSpellS)
                            Toggle("Matériel (M)", isOn: $newSpellM)
                            
                            if newSpellM {
                                TextField("Spécifiez le matériel (ex: une plume)", text: $newSpellMaterialDescription)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .navigationTitle("Nouveau Sort")
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
                                addSpell()
                                isShowingAddSheet = false
                                resetForm()
                            }
                            .disabled(newSpellName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        } detail: {
            Text("Sélectionnez un sort")
        }
    }

    private func addSpell() {
        withAnimation {
            let newSpell = Spell(
                timestamp: Date(),
                name: newSpellName,
                portee: newSpellPortee.isEmpty ? "Personnelle" : newSpellPortee,
                ecole: newSpellEcole,
                componentV: newSpellV,
                componentS: newSpellS,
                componentM: newSpellM,
                materialDescription: newSpellM ? newSpellMaterialDescription : "",
                dureeIncantation: newSpellDuree.isEmpty ? "1 action" : newSpellDuree
            )
            modelContext.insert(newSpell)
        }
    }

    private func deleteSpells(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(spells[index])
            }
        }
    }

    private func resetForm() {
        newSpellName = ""
        newSpellPortee = ""
        newSpellEcole = "Évocation"
        newSpellV = false
        newSpellS = false
        newSpellM = false
        newSpellMaterialDescription = ""
        newSpellDuree = ""
    }
}

// MARK: - VUE DE DÉTAIL AVEC MODE LECTURE / ÉDITION
struct SpellDetailView: View {
    @Bindable var spell: Spell
    
    // Gère l'état d'édition de la page
    @State private var isEditing = false
    
    let ecolesDeMagie = [
        "Abjuration", "Conjuration", "Divination", "Enchantement",
        "Évocation", "Illusion", "Nécromancie", "Transmutation"
    ]

    var body: some View {
        Form {
            Section(header: Text("Informations Générales")) {
                if isEditing {
                    TextField("Nom du sort", text: $spell.name)
                    Picker("École de magie", selection: $spell.ecole) {
                        ForEach(ecolesDeMagie, id: \.self) { ecole in
                            Text(ecole).tag(ecole)
                        }
                    }
                } else {
                    LabeledContent("Nom", value: spell.name)
                    LabeledContent("École", value: spell.ecole)
                }
            }
            
            Section(header: Text("Caractéristiques de Lancement")) {
                if isEditing {
                    TextField("Portée", text: $spell.portee)
                    TextField("Durée d'incantation", text: $spell.dureeIncantation)
                } else {
                    LabeledContent("Portée", value: spell.portee)
                    LabeledContent("Incantation", value: spell.dureeIncantation)
                }
            }
            
            Section(header: Text("Composantes")) {
                if isEditing {
                    Toggle("Verbal (V)", isOn: $spell.componentV)
                    Toggle("Somatique (S)", isOn: $spell.componentS)
                    Toggle("Matériel (M)", isOn: $spell.componentM)
                    
                    if spell.componentM {
                        TextField("Spécifiez le matériel", text: $spell.materialDescription)
                            .transition(.opacity)
                    }
                } else {
                    LabeledContent("Composantes", value: spell.formattedComponents)
                    
                    // En lecture seule, si M est coché et qu'il y a un texte, on l'affiche proprement en dessous
                    if spell.componentM && !spell.materialDescription.isEmpty {
                        LabeledContent("Détail du matériel", value: spell.materialDescription)
                    }
                }
            }
        }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Bouton dynamique Modifier / OK
                Button(isEditing ? "OK" : "Modifier") {
                    withAnimation {
                        isEditing.toggle()
                        
                        // Sécurité : Si l'utilisateur a décoché M pendant l'édition, on vide la description
                        if !spell.componentM {
                            spell.materialDescription = ""
                        }
                    }
                }
            }
        }
    }
}
