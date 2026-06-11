//
//  PageIndicator.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI

/// Indicateur de page pour le TabView
struct PageIndicator: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(isActive ? .bold : .regular)
                .foregroundColor(isActive ? .blue : .secondary)
            
            Rectangle()
                .fill(isActive ? Color.blue : Color.clear)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity)
    }
}
