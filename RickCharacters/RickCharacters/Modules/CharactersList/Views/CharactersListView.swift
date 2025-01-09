//
//  CharactersListView.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - CharactersListView
struct CharactersListView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    // used to convert ViewController (CharactersListViewController) to SwiftUI view to can be used with SwiftUI
    func makeUIViewController(context: Context) -> UINavigationController {
        let characterListVC = CharactersListViewController()
        let navigationController = UINavigationController(rootViewController: characterListVC)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // If you need to update the navigation controller, you can do it here
        // For example, you can push new view controllers or modify the navigation bar.
    }
}
