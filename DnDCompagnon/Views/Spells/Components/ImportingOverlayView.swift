//
//  ImportingOverlayView.swift
//  DnDCompagnon
//

import SwiftUI

struct ImportingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView("Importation en cours...")
                .padding()
                .background(.background)
                .cornerRadius(10)
        }
    }
}
