//
//  CharactersListRepository.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation
import Combine

protocol CharactersListRepositoryProtocol {
    func fetch(from endpoint: String) throws
    var charactersListModel: AnyPublisher<CharactersListModel?, Never> { get }
}

// MARK: - CharactersListRepository
class CharactersListRepository: CharactersListRepositoryProtocol {
    private let charactersListDataService = CharactersListDataService()
    private let charactersListModelSubject = CurrentValueSubject<CharactersListModel?, Never>(nil)
    
    var charactersListModel: AnyPublisher<CharactersListModel?, Never> {
        charactersListModelSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        charactersListDataService.$charactersListModel
            .dropFirst()
            .sink { [weak self] (returnedCharactersListModel) in
                self?.charactersListModelSubject.send(returnedCharactersListModel)
            }
            .store(in: &cancellables)
    }

    func fetch(from endpoint: String) throws {
        do {
            try charactersListDataService.getCharacters(from: endpoint)
        } catch {
            // TODO: - get Character List locally (Storage, CoreData, SwiftData,...)
            throw error
        }
    }
}
