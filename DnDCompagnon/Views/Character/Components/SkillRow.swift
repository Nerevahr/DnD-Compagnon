//
//  SkillRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//


//
//  SkillRow.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Ligne affichant une compétence
struct SkillRow: View {
    let character: Character
    let skill: DnDSkill
    
    var isProficient: Bool {
        character.proficientSkills.contains(skill.name)
    }
    
    var modifier: Int {
        character.skillModifier(for: skill)
    }
    
    var modifierString: String {
        modifier >= 0 ? "+\(modifier)" : "\(modifier)"
    }
    
    var body: some View {
        HStack {
            if isProficient {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.body)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.body)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(skill.name)
                    .font(.body)
                Text(skill.baseStat)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(modifierString)
                .font(.title3)
                .fontWeight(isProficient ? .bold : .regular)
                .foregroundColor(isProficient ? .green : .primary)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
