//
//  EmptyAbilitiesView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//


//
//  EmptyAbilitiesView.swift
//  DnDCompagnon
//

import SwiftUI

struct EmptyAbilitiesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("Aucune aptitude disponible")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Les aptitudes de classe apparaîtront ici")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    EmptyAbilitiesView()
}