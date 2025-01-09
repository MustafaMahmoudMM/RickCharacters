//
//  Repository.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation

// MARK: - Repository Porotocol
protocol Repository {
    func fetch(from endpoint: String) throws
}
