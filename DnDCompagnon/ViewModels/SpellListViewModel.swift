//
//  SpellListViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


//
//  SpellListViewModel.swift
//  DnDCompagnon
//

import Foundation
import SwiftData

/// Etat et logique métier de la liste des sorts
@Observable
final class SpellListViewModel {

    // MARK: - UI State
    var isShowingAddSheet = false
    var isShowingFilterSheet = false
    var isImporting = false

    // MARK: - Alerts
    var importErrorMessage: String?
    var showImportError = false
    var importSuccessCount = 0
    var showImportSuccess = false

    // MARK: - Filtres
    var filterNiveaux: Set<Int> = []
    var filterClasses: Set<String> = []
    var filterEcoles: Set<String> = []
    var filterConcentration: Bool? = nil

    // MARK: - Formulaire d'ajout
    var newSpellName = ""
    var newSpellPortee = ""
    var newSpellEcole = "Évocation"
    var newSpellV = false
    var newSpellS = false
    var newSpellM = false
    var newSpellMaterialDescription = ""
    var newSpellDuree = ""
    var newSpellDureeSortComplete = "Instantanée"
    var newSpellNiveau = 1
    var newSpellClasses: Set<String> = []
    var newSpellConcentration = false
    var newSpellDescription = ""

    // MARK: - Computed: filtres

    var hasActiveFilters: Bool {
        !filterNiveaux.isEmpty || !filterClasses.isEmpty ||
        !filterEcoles.isEmpty || filterConcentration != nil
    }

    var activeFilterCount: Int {
        filterNiveaux.count + filterClasses.count +
        filterEcoles.count + (filterConcentration != nil ? 1 : 0)
    }

    func filteredAndGrouped(_ spells: [Spell]) -> [Int: [Spell]] {
        let filtered = spells.filter { spell in
            if !filterNiveaux.isEmpty && !filterNiveaux.contains(spell.niveau) { return false }
            if !filterClasses.isEmpty && !spell.classes.contains(where: { filterClasses.contains($0) }) { return false }
            if !filterEcoles.isEmpty && !filterEcoles.contains(spell.ecole) { return false }
            if let needsConcentration = filterConcentration, spell.concentration != needsConcentration { return false }
            return true
        }
        return Dictionary(grouping: filtered, by: { $0.niveau })
    }

    func resetFilters() {
        filterNiveaux = []
        filterClasses = []
        filterEcoles = []
        filterConcentration = nil
    }

    // MARK: - Actions

    func addSpell(context: ModelContext) {
        let newSpell = Spell(
            timestamp: Date(),
            name: newSpellName,
            portee: newSpellPortee.isEmpty ? "Personnelle" : newSpellPortee,
            ecole: newSpellEcole,
            componentV: newSpellV,
            componentS: newSpellS,
            componentM: newSpellM,
            materialDescription: newSpellM ? newSpellMaterialDescription : "",
            dureeIncantation: newSpellDuree.isEmpty ? "1 action" : newSpellDuree,
            duree: newSpellDureeSortComplete,
            niveau: newSpellNiveau,
            classes: Array(newSpellClasses).sorted(),
            concentration: newSpellConcentration,
            descriptionSort: newSpellDescription
        )
        context.insert(newSpell)
        resetForm()
    }

    func deleteSpells(_ spells: [Spell], context: ModelContext) {
        spells.forEach { context.delete($0) }
    }

    func importSpells(from url: URL, context: ModelContext) async {
        isImporting = true
        defer { isImporting = false }

        guard url.startAccessingSecurityScopedResource() else {
            importErrorMessage = "Impossible d'accéder au fichier"
            showImportError = true
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let data = try Data(contentsOf: url)
            let spellsJSON = try JSONDecoder().decode([SpellJSON].self, from: data)
            for spellJSON in spellsJSON {
                context.insert(spellJSON.toSpell())
            }
            importSuccessCount = spellsJSON.count
            showImportSuccess = true
        } catch let decodingError as DecodingError {
            importErrorMessage = "Erreur de format JSON : \(decodingError.localizedDescription)"
            showImportError = true
        } catch {
            importErrorMessage = "Erreur lors de l'importation : \(error.localizedDescription)"
            showImportError = true
        }
    }

    // MARK: - Helpers

    func niveauSectionHeader(_ niveau: Int) -> String {
        niveau == 0 ? "Tours de magie" : "Niveau \(niveau)"
    }

    func resetForm() {
        newSpellName = ""
        newSpellPortee = ""
        newSpellEcole = "Évocation"
        newSpellV = false
        newSpellS = false
        newSpellM = false
        newSpellMaterialDescription = ""
        newSpellDuree = ""
        newSpellDureeSortComplete = "Instantanée"
        newSpellNiveau = 1
        newSpellClasses = []
        newSpellConcentration = false
        newSpellDescription = ""
    }
}