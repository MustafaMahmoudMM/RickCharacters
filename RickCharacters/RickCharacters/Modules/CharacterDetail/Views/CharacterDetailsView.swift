//
//  CharacterDetailsView.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import SwiftUI

struct CharacterDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    let character: CharacterModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack {
                    characterImage
                        .padding(2)
                    
                    allInfoView
                }
            }
            .ignoresSafeArea(edges: .top)
            
            backButtonView
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CharacterDetailsView(character: CharacterModel(
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

extension CharacterDetailsView {
    private var characterImage: some View {
        AsyncImage(url: URL(string: character.image)) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "photo.fill")
                .resizable()
        }
        .scaledToFit()
        .clipShape(
            .rect(
                topLeadingRadius: 20,
                bottomLeadingRadius: 40,
                bottomTrailingRadius: 40,
                topTrailingRadius: 20
            )
        )
    }
    
    private var personalInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(character.name)
                .font(.title)
                .bold()
            
            HStack {
                Text(character.species)
                Text("•")
                Text(character.gender.rawValue.capitalized)
                    .foregroundStyle(.gray)
            }
            .font(.subheadline)
            .bold()
        }
    }
    
    private var allInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                personalInfoView
                
                Spacer()
                
                Text(character.status.rawValue.capitalized)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyan.opacity(0.6))
                    .clipShape(Capsule())
                    .padding(.top, 8)
            }
            
            HStack {
                Text("Location: ")
                    .font(.title2)
                    .bold()
                
                Text(character.location.name)
            }
        }
        .padding(.horizontal, 25)
        .padding(.top, 20)
    }
    
    private var backButtonView: some View {
        VStack {
            Button(action: {
                withAnimation(.none) {
                    dismiss.callAsFunction()
                }
            }) {
                Image(systemName: "arrow.left")
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .clipShape(.circle)
            }
            .ignoresSafeArea(edges: .top)
            .padding(.top, 20)
            .padding(.leading, 8)
        }
    }
}
