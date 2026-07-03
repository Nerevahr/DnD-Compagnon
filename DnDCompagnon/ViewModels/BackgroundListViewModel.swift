//
//  BackgroundListViewModel.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


// ViewModels/BackgroundListViewModel.swift
import Foundation
import Observation

@Observable
final class BackgroundListViewModel {
    var searchText: String = ""

    func filtered(_ backgrounds: [Background]) -> [Background] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return backgrounds }
        return backgrounds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}