//
//  SavingThrowRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  SavingThrowRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Ligne affichant un jet de sauvegarde
struct SavingThrowRow: View {
    let character: Character
    let stat: String
    
    var isProficient: Bool {
        character.dndClass?.masteredStats.contains(stat) ?? false
    }
    
    var total: Int {
        character.savingThrow(for: stat)
    }
    
    var totalString: String {
        total >= 0 ? "+\(total)" : "\(total)"
    }
    
    var body: some View {
        HStack {
            if isProficient {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Text(stat)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(totalString)
                .fontWeight(isProficient ? .bold : .regular)
                .foregroundColor(isProficient ? .blue : .primary)
        }
    }
}