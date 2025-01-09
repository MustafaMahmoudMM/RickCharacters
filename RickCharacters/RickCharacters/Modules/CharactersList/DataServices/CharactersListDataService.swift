//
//  CharactersListDataService.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation
import Combine

// MARK: - CharactersListDataService
class CharactersListDataService {
    
    @Published var charactersListModel: CharactersListModel?
    var charactersListSubscription: AnyCancellable?
    
    func getCharacters(from endpoint: String) throws {
        do {
            charactersListSubscription = try NetworkManager.fetch(from: endpoint)
                .decode(type: CharactersListModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: {  [weak self] (returnedCharactersListModel) in
                    self?.charactersListModel = returnedCharactersListModel
                    self?.charactersListSubscription?.cancel()
                })
        } catch {
            throw error
        }
    }
}
