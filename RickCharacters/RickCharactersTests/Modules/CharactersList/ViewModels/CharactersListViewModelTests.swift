//
//  CharactersListViewModelTests.swift
//  RickCharactersTests
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import XCTest
import Combine
@testable import RickCharacters

final class CharactersListViewModelTests: XCTestCase {
    private var viewModel: CharactersListViewModel!
    private var mockRepository: MockCharactersListRepository!

    // Called before each test is run
    override func setUp() {
        super.setUp()
        mockRepository = MockCharactersListRepository()
        viewModel = CharactersListViewModel(charactersListRepository: mockRepository)
        viewModel.charactersListRepository = mockRepository // Inject the mock repository
    }

    // Called after each test is run
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    // Test for successfully loading characters
    func testLoadCharactersSuccess() {
        // Arrange
        let mockCharacters = [
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 1, image: "", location: Location(name: "", url: ""), name: "Rick Sanchez", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: ""),
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 2, image: "", location: Location(name: "", url: ""), name: "Morty Smith", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: "")
        ]
        mockRepository.mockCharacters = mockCharacters

        // Act
        viewModel.loadCharacters()

        // Assert
        XCTAssertEqual(viewModel.characters.count, mockCharacters.count, "The number of characters loaded should match the mocked data.")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez", "The first character's name should be Rick Sanchez.")
        XCTAssertNotNil(viewModel.charactersListRepository, "The repository should be assigned to the ViewModel.")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading.")
        XCTAssertNil(viewModel.error, "Error should be nil when loading succeeds.")
    }

    // Test for filtering characters by status
    func testFilterCharactersByStatus() {
        // Arrange
        let mockCharacters = [
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 1, image: "", location: Location(name: "", url: ""), name: "Rick Sanchez", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: ""),
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 2, image: "", location: Location(name: "", url: ""), name: "Birdperson", origin: Origin(name: "", url: ""), species: "Human", status: .dead, type: "", url: "")
        ]
        mockRepository.mockCharacters = mockCharacters

        // Act
        viewModel.filterCharacters(by: .alive)
        do {
            try viewModel.charactersListRepository.fetch(from: "")
        } catch {}

        // Assert
        XCTAssertEqual(viewModel.selectedStatus, .alive, "Selected status should be Alive.")
        XCTAssertEqual(viewModel.characters.count, 1, "Filtered characters count should be 1.")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez", "The filtered character's name should be Rick Sanchez.")
    }

    // Test for pagination (loading more characters)
    func testLoadMoreCharacters() {
        // Arrange
        let mockCharactersPage1 = [
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 1, image: "", location: Location(name: "", url: ""), name: "Rick Sanchez", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: ""),
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 2, image: "", location: Location(name: "", url: ""), name: "Morty Smith", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: "")
        ]
        let mockCharactersPage2 = [
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 3, image: "", location: Location(name: "", url: ""), name: "Summer Smith", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: ""),
            CharacterModel(
                created: "", episode: [""], gender: .male, id: 4, image: "", location: Location(name: "", url: ""), name: "Beth Smith", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: "")
        ]
        mockRepository.mockCharacters = mockCharactersPage1
        viewModel.loadCharacters()

        // Simulate loading more characters
        mockRepository.mockCharacters = mockCharactersPage2
        viewModel.loadCharacters(loadMore: true)

        // Assert
        XCTAssertEqual(viewModel.characters.count, 4, "Total characters should be 4 after loading more.")
        XCTAssertEqual(viewModel.characters.last?.name, "Beth Smith", "The last character's name should be Beth Smith.")
    }

    // Test for handling errors
    func testErrorHandling() {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act
        viewModel.loadCharacters()

        // Assert
        XCTAssertNotNil(viewModel.error, "Error should not be nil when loading fails.")
        XCTAssertTrue(viewModel.characters.isEmpty, "Characters should be empty when loading fails.")
    }
}


final class MockCharactersListRepository: CharactersListRepositoryProtocol {
    private var cancellables = Set<AnyCancellable>()
    private let charactersListModelSubject = CurrentValueSubject<CharactersListModel?, Never>(nil)
    
    var charactersListModel: AnyPublisher<CharactersListModel?, Never> {
        charactersListModelSubject.eraseToAnyPublisher()
    }
    
    var mockCharacters: [CharacterModel] = [
//        CharacterModel(
//            created: "", episode: [""], gender: .male, id: 1, image: "", location: Location(name: "", url: ""), name: "Rick Sanchez", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: ""),
//        CharacterModel(
//            created: "", episode: [""], gender: .male, id: 2, image: "", location: Location(name: "", url: ""), name: "Morty Smith", origin: Origin(name: "", url: ""), species: "Human", status: .alive, type: "", url: "")
    ]
    var shouldThrowError = false

    func fetch(from endpoint: String) throws {
        print("fetch called with endpoint: \(endpoint)") // Debug print
        if shouldThrowError {
            throw NSError(domain: "Mock error", code: 0)
        }

        let mockInfo = Info(count: 20, next: "next", pages: 40, prev: "prev")
        let model = CharactersListModel(info: mockInfo, characters: mockCharacters.filter({$0.status == .alive}))
        charactersListModelSubject.send(model)
    }
}
