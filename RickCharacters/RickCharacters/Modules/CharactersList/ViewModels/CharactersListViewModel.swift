//
//  CharactersListViewModel.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation
import Combine

// MARK: - CharactersListViewModel
class CharactersListViewModel: ObservableObject {
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var selectedStatus: Status?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private var currentPage = 1
    private var canLoadMore = true
    private var isLoadMore = false
    
    var charactersListRepository: CharactersListRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(charactersListRepository: CharactersListRepositoryProtocol) {
        self.charactersListRepository = charactersListRepository
        self.addSubscribers()
        isLoading = false
    }
    
    func addSubscribers() {
        charactersListRepository.charactersListModel
            .dropFirst()
            .sink { [weak self] (returnedCharactersListModel) in
                if self?.isLoadMore ?? false {
                    self?.characters.append(contentsOf: returnedCharactersListModel?.characters ?? [])
                } else {
                    self?.characters = returnedCharactersListModel?.characters ?? []
                }
                self?.canLoadMore = returnedCharactersListModel?.info.next != nil
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func loadCharacters(loadMore: Bool = false) {
        guard !isLoading else { return }
        
        isLoadMore = loadMore
        if loadMore {
            currentPage += 1
        } else {
            characters = []
            currentPage = 1
            canLoadMore = true
        }
        
        isLoading = true
        do {
            var endpoint = "/character?page=\(currentPage)"
            if let status = selectedStatus {
                endpoint += "&status=\(status.rawValue.lowercased())"
            }
            
            try charactersListRepository.fetch(from: endpoint)
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
    
    func filterCharacters(by status: Status?) {
        selectedStatus = selectedStatus != status ? status : nil
        loadCharacters()
    }
    
    func loadMoreIfNeeded(for character: CharacterModel) {
        guard let index = characters.firstIndex(where: { $0.id == character.id }),
              index == characters.count - 5,
              canLoadMore else {
            return
        }
        loadCharacters(loadMore: true)
    }
}
