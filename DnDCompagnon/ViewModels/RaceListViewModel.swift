//
//  RaceListViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// ViewModels/RaceListViewModel.swift
import Foundation
import Observation

@Observable
final class RaceListViewModel {
    var searchText: String = ""

    func filtered(_ races: [Race]) -> [Race] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return races }
        return races.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}