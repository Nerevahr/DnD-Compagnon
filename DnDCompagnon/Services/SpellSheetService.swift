//
//  SpellSheetService.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 30/07/2026.
//

import Foundation
import SwiftData

enum SpellSheetService {

    @MainActor
    static func createSpellSheet(title: String, context: ModelContext) throws -> SpellSheet {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw SpellSheetCreationError.invalidTitle
        }

        let spellSheet = SpellSheet(title: trimmedTitle)

        context.insert(spellSheet)
        try context.save()

        return spellSheet
    }
}

enum SpellSheetCreationError: Error {
    case invalidTitle
}
