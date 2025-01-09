//
//  NetworkManager.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case serverError(Int)
    case unknown
}

// MARK: - NetworkManaging Porotocol
protocol NetworkManaging {
    static func fetch(from endpoint: String) throws -> AnyPublisher<Data, any Error>
}

// MARK: - Confirming NetworkManaging Porotocol
final class NetworkManager: NetworkManaging {
    static private let baseURL = "https://rickandmortyapi.com/api"
    
    static func fetch(from endpoint: String) throws -> AnyPublisher<Data, any Error> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.serverError(response.statusCode)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
                break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
