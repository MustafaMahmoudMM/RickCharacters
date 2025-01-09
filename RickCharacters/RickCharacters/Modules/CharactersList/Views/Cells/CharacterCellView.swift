//
//  CharacterCellView.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import SwiftUI

struct CharacterCellView: View {
    let character: CharacterModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
            }
            .scaledToFit()
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    character.status == .alive ? Color(.systemBackground) :
                        character.status == .dead ? Color.pink.opacity(0.2) :
                        Color.blue.opacity(0.2)
                )
                .stroke(Color.black.opacity(character.status == .alive ? 0.1 : 0.0), lineWidth: 1)
        )
        .padding(.trailing, 36)
    }
}

#Preview {
    CharacterCellView(character: CharacterModel(
        created: "2018-01-10T18:20:41.703Z",
        episode: ["https://rickandmortyapi.com/api/episode/27"]
                                           ,
        gender: .male,
        id: 361, image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
        location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
        name: "Toxic Rick",
        origin: Origin(name: "Alien Spa", url: "https://rickandmortyapi.com/api/location/64"),
        species: "Humanoid",
        status: .dead,
        type: "Rick's Toxic Side",
        url: "https://rickandmortyapi.com/api/character/361"))
}
