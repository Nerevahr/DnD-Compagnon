//
//  GoldEditorView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 02/07/2026.
//

import SwiftUI

/// Vue pour éditer la quantité d'or
struct GoldEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var gold: Double
    @State private var goldText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Icône
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .padding(.top, 32)
                
                // Champ d'édition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quantité d'or")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("0.00", text: $goldText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 48, weight: .bold))
                            .multilineTextAlignment(.center)
                            .focused($isTextFieldFocused)
                        
                        Text("po")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                }
                .padding(.horizontal)
                
                // Suggestions rapides
                VStack(alignment: .leading, spacing: 12) {
                    Text("Actions rapides")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        QuickGoldButton(label: "+10", value: 10, currentGold: $goldText)
                        QuickGoldButton(label: "+50", value: 50, currentGold: $goldText)
                        QuickGoldButton(label: "+100", value: 100, currentGold: $goldText)
                        QuickGoldButton(label: "Réinitialiser", value: nil, currentGold: $goldText)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Éditer l'or")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Valider") {
                        saveGold()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                goldText = String(format: "%.2f", gold)
                isTextFieldFocused = true
            }
        }
    }
    
    private func saveGold() {
        if let value = Double(goldText.replacingOccurrences(of: ",", with: ".")) {
            gold = max(0, value) // Ne pas autoriser les valeurs négatives
        }
    }
}

/// Bouton pour ajouter rapidement de l'or
struct QuickGoldButton: View {
    let label: String
    let value: Double?
    @Binding var currentGold: String
    
    var body: some View {
        Button {
            if let value = value {
                let current = Double(currentGold.replacingOccurrences(of: ",", with: ".")) ?? 0
                currentGold = String(format: "%.2f", current + value)
            } else {
                currentGold = "0.00"
            }
        } label: {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(value == nil ? Color.red.opacity(0.1) : Color.orange.opacity(0.1))
                .foregroundColor(value == nil ? .red : .orange)
                .cornerRadius(8)
        }
    }
}
