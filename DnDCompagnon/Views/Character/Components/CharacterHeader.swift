//
//  CharacterHeader.swift
//  DnDCompagnon
//
//  Created by Mathieu Verpillat on 11/06/2026.
//

import SwiftUI
import PhotosUI

struct CharacterHeader: View {
    let character: Character
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: Image?
    
    var hpPercentage: Double {
        Double(character.currentHitPoints) / Double(character.maximumHitPoints)
    }
    
    var hpColor: Color {
        if hpPercentage > 0.5 { return .green }
        if hpPercentage > 0.25 { return .orange }
        return .red
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // HStack existant pour les infos et la photo
            HStack(alignment: .top, spacing: 16) {
                // Informations du personnage à gauche (sans les PV)
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        if let race = character.race {
                            Label(race.name, systemImage: "person.fill")
                                .foregroundColor(.green)
                        }
                        if let origin = character.origin  {
                            Label(origin.name, systemImage: "book.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    .font(.subheadline)
                    
                    HStack {
                        if let dndClass = character.dndClass {
                            Label(dndClass.name, systemImage: "shield.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.headline)
                    
                    Label("Niveau \(character.level)", systemImage: "bookmark.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Photo du personnage en haut à droite
                VStack(spacing: 8) {
                    ZStack(alignment: .bottomTrailing) {
                        if let image = profileImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else if let data = character.profileImageData,
                                  let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            // Placeholder
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                }
                        }
                        
                        // Badge pour changer la photo
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Image(systemName: "camera")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                        .offset(x: 4, y: 4)
                    }
                }
            }
            
            // Barre de PV en dessous, sur toute la largeur
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("Points de vie", systemImage: "heart.fill")
                        .font(.subheadline)
                        .foregroundColor(hpColor)
                    Spacer()
                    Text("\(character.currentHitPoints) / \(character.maximumHitPoints)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                ProgressView(value: hpPercentage)
                    .tint(hpColor)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    character.profileImageData = data
                    if let uiImage = UIImage(data: data) {
                        profileImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
        .onAppear {
            if let data = character.profileImageData,
               let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }
        }
    }
}
