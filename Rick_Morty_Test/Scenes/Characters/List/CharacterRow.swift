//
//  CharacterRow.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 06.11.2024.
//

import SwiftUI
import Kingfisher

struct CharacterRow: View {
    var character: Character?
    var size: CGFloat = 50
    
    var body: some View {
        HStack {
            KFImage(character?.image)
                .placeholder {
                    Image("placeholder")
                        .resizable()
                        .frame(width: size, height: size, alignment: .center)
                }
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(character?.name ?? "Nan")
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(color(by: character?.status ?? .unknown))
                    
                    Text(character?.status.rawValue ?? "Nan")
                        .font(.subheadline)
                }
            }.foregroundStyle(.white)
            Spacer()
        }.listRowBackground(Color(red: 0.239, green: 0.243, blue: 0.269))
    }
    
    private func color(by status: Character.Status) -> Color {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
}

#Preview {
    CharacterRow()
}
