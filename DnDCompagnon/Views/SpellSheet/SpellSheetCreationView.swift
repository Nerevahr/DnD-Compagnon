//
//  SpellSheetCreationView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import SwiftUI
import SwiftData

/// Vue de création d'une nouvelle fiche de sorts (titre uniquement)
struct SpellSheetCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var creationError: Error?
    @State private var showingCreationError = false

    var onCreated: (() -> Void)?

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Titre") {
                    TextField("Nom de la fiche", text: $title)
                }
            }
            .navigationTitle("Nouvelle fiche de sorts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Créer") {
                        createSpellSheet()
                    }
                    .disabled(!isValid)
                }
            }
            .alert("Erreur", isPresented: $showingCreationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(creationError?.localizedDescription ?? "Une erreur est survenue lors de la création")
            }
        }
    }

    private func createSpellSheet() {
        do {
            _ = try SpellSheetService.createSpellSheet(title: title, context: modelContext)
            onCreated?()
            dismiss()
        } catch {
            creationError = error
            showingCreationError = true
        }
    }
}
