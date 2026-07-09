//
//  SpellDetailView.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 12/06/2026.
//

import SwiftUI

struct SpellDetailView: View {
    @Bindable var spell: Spell
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SpellCardHeaderView(spell: spell)
                SpellCardSummaryView(spell: spell)
                SpellCardStatsView(spell: spell)
                SpellCardDescriptionView(spell: spell)
                SpellCardFooterView()
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding()
        }
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Modifier") {
                    isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            SpellEditView(spell: spell)
        }
    }
}

// MARK: - Card Header View
private struct SpellCardHeaderView: View {
    let spell: Spell
    
    var schoolColor: Color {
        SpellCardThemeHelper.schoolColor(for: spell.ecole)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(spell.name)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .lineLimit(1)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("LVL")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("\(spell.niveau)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            HStack {
                Text(spell.ecole)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(schoolColor)
                    .cornerRadius(4)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(schoolColor.opacity(0.15))
        }
    }
}

// MARK: - Card Summary View (School Icon + Brief Description)
private struct SpellCardSummaryView: View {
    let spell: Spell
    
    var schoolIcon: String {
        SpellCardThemeHelper.schoolIcon(for: spell.ecole)
    }
    
    var shortDescription: String {
        let sentences = spell.descriptionSort.split(separator: ".").first.map(String.init) ?? spell.descriptionSort
        return sentences.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack {
                Image(systemName: schoolIcon)
                    .font(.system(size: 32))
                    .foregroundColor(SpellCardThemeHelper.schoolColor(for: spell.ecole))
            }
            .frame(width: 70, height: 70)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(35)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(shortDescription)
                    .font(.body)
                    .lineLimit(3)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(16)
        .background(SpellCardThemeHelper.schoolColor(for: spell.ecole).opacity(0.1))
    }
}

// MARK: - Card Stats View (Casting Time, Range, Components, Duration)
private struct SpellCardStatsView: View {
    let spell: Spell
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            InfoRow(label: "Temps d'incantation", value: spell.dureeIncantation)
            InfoRow(label: "Portée", value: spell.portee)
            InfoRow(label: "Composantes", value: spell.formattedComponents)
            
            if spell.componentM && !spell.materialDescription.isEmpty {
                InfoRow(label: "Matériel", value: spell.materialDescription)
            }
            
            InfoRow(label: "Durée", value: spell.duree)
            
            if spell.concentration {
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.orange)
                        .font(.caption2)
                    Text("Concentration")
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                        .font(.body)
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.06))
    }
}

// MARK: - Card Description View (Full Description + Offensive Stats + Classes)
private struct SpellCardDescriptionView: View {
    let spell: Spell
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Full Description
            if !spell.descriptionSort.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(.init(spell.descriptionSort))
                        .font(.body)
                        .lineLimit(nil)
                }
            }
            
            // Offensive Info
            if spell.isOffensive {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.red)
                        Text("Sort offensif")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                    if let damage = spell.damageAmount {
                        InfoRow(label: "Dégâts", value: damage)
                    }
                    
                    if let altDamage = spell.alternateDamageAmount {
                        InfoRow(label: "Dégâts alternatifs", value: altDamage)
                    }
                    
                    if spell.requiresSavingThrow, let stat = spell.savingThrowStat {
                        HStack(spacing: 8) {
                            Image(systemName: "shield.fill")
                                .foregroundColor(.blue)
                            Text("Jet de sauvegarde : \(stat)")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(12)
                .background(Color.red.opacity(0.08))
                .cornerRadius(8)
            }
            
            // Classes
            if !spell.classes.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Classes")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(spell.classes, id: \.self) { classe in
                                Text(classe)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.accentColor.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Card Footer View
private struct SpellCardFooterView: View {
    var body: some View {
        HStack {
            Text("©2026 Wizards")
                .font(.caption2)
                .foregroundColor(.gray)
            Spacer()
            Image(systemName: "triangle.fill")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.gray.opacity(0.03))
        .cornerRadius(0, corners: [.bottomLeft, .bottomRight])
    }
}

// MARK: - Theme Helper
private struct SpellCardThemeHelper {
    static func schoolColor(for schoolName: String) -> Color {
        switch schoolName.lowercased() {
        case "abjuration":
            return Color(red: 0.4, green: 0.5, blue: 0.8)
        case "conjuration":
            return Color(red: 0.6, green: 0.3, blue: 0.7)
        case "divination":
            return Color(red: 0.3, green: 0.6, blue: 0.8)
        case "enchantement":
            return Color(red: 0.9, green: 0.5, blue: 0.7)
        case "évocation":
            return Color(red: 0.9, green: 0.2, blue: 0.2)
        case "illusion":
            return Color(red: 0.8, green: 0.5, blue: 0.8)
        case "nécromancie":
            return Color(red: 0.4, green: 0.2, blue: 0.4)
        case "transmutation":
            return Color(red: 0.2, green: 0.7, blue: 0.5)
        default:
            return Color.accentColor
        }
    }
    
    static func schoolIcon(for schoolName: String) -> String {
        switch schoolName.lowercased() {
        case "abjuration":
            return "shield.fill"
        case "conjuration":
            return "sparkles"
        case "divination":
            return "eye.fill"
        case "enchantement":
            return "heart.fill"
        case "évocation":
            return "flame.fill"
        case "illusion":
            return "theatermasks.fill"
        case "nécromancie":
            return "skull.fill"
        case "transmutation":
            return "wand.and.stars"
        default:
            return "book.fill"
        }
    }
}

// MARK: - Corner Radius with Specific Corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SpellDetailView(spell: MockData.fireBolt)
}
