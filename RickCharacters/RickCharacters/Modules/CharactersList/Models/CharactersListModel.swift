//
//  CharactersListModel.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation

// MARK: - CharactersListModel
struct CharactersListModel: Codable {
    let info: Info
    let characters: [CharacterModel]
    
    enum CodingKeys: String, CodingKey {
        case info
        case characters = "results"
    }
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let next: String?
    let pages: Int
    let prev: String?
}
