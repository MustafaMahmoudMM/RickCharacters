//
//  RickCharactersApp.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import SwiftUI

@main
struct RickCharactersApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CharactersListView()
                    .navigationTitle("Characters")
            }
        }
    }
}
