//
//  CharacterDetailView.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 06.11.2024.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    var character: Character

    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.white, Color(red: 0.155, green: 0.169, blue: 0.199)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)

            KFImage(character.image).placeholder {
                Image("placeholder")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 180, height: 180)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 10)
            .offset(y: -120)
            .padding(.bottom, -120)

            Text(character.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 32) {
                    Text("Status:")
                        .fontWeight(.bold)
                    Text(character.status.rawValue)
                    }
                    HStack(spacing: 32) {
                        Text("Gender:")
                            .fontWeight(.bold)
                        Text(character.gender)
                    }
                    HStack(spacing: 32) {
                        Text("Species:")
                            .fontWeight(.bold)
                        Text(character.species)
                    }
                    HStack(spacing: 32) {
                        Text("Location:")
                            .fontWeight(.bold)
                        Text(character.location.name)
                    }
                    HStack(spacing: 32) {
                        Text("Origin:")
                            .fontWeight(.bold)
                        Text(character.origin.name)
                    }
                    
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .padding(.top, 16)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }.background(Color(red: 0.155, green: 0.169, blue: 0.199))
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    CharacterDetailView(character: .mock)
}
