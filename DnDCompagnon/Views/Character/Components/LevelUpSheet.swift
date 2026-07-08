//
//  LevelUpSheet.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 08/07/2026.
//

import SwiftUI
import SwiftData

struct LevelUpSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var character: Character
    let newLevel: Int
    
    @State private var dieRoll: Int = 1
    
    var expectedMinHP: Int {
        1
    }
    
    var expectedMaxHP: Int {
        10 + newLevel
    }
    
    var hpGain: Int {
        max(1, dieRoll + character.constitutionModifier)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // En-tête
            VStack(spacing: 8) {
                Text("Augmentation de niveau")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Niveau \(character.level) → \(newLevel)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Section des stats
            VStack(alignment: .leading, spacing: 16) {
                // Affichage du modificateur de Constitution
                HStack {
                    Text("Modificateur de Constitution")
                        .font(.subheadline)
                    Spacer()
                    Text("\(character.constitutionModifier > 0 ? "+" : "")\(character.constitutionModifier)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                // Saisie du dé
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Résultat du dé")
                            .font(.subheadline)
                        Spacer()
                        Text("(1-10, 1-12 ou 1-d'autres)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: { if dieRoll > 1 { dieRoll -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title3)
                        }
                        
                        TextField("Résultat", value: $dieRoll, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(height: 44)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { dieRoll += 1 }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                
                // Calcul des PV gagnés
                VStack(spacing: 8) {
                    Divider()
                    
                    HStack {
                        Text("Gain de PV")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(dieRoll) + \(character.constitutionModifier > 0 ? "+" : "")\(character.constitutionModifier) = \(hpGain)")
                                .font(.subheadline)
                            Text("(minimum 1 PV)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    HStack {
                        Text("Nouveaux PV max")
                            .font(.subheadline)
                        Spacer()
                        Text("\(character.maximumHitPoints) + \(hpGain) = \(character.maximumHitPoints + hpGain)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            
            Spacer()
            
            // Boutons
            HStack(spacing: 12) {
                Button("Annuler") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Button(action: confirmLevelUp) {
                    Text("Confirmer")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func confirmLevelUp() {
        character.levelUp(dieRoll: dieRoll)
        
        // Valider que les données sont cohérentes après la montée
        if let error = character.validateIntegrity() {
            print("⚠️  VALIDATION ERROR after levelUp: \(error)")
            character.printDiagnostics()
        }
        
        // Force la sauvegarde explicite dans SwiftData
        try? modelContext.save()
        
        dismiss()
    }
}

#Preview {
    LevelUpSheet(character: MockData.fighter, newLevel: 2)
}
