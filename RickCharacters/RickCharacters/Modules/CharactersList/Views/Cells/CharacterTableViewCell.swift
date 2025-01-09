//
//  CharacterTableViewCell.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import UIKit
import SwiftUI

// MARK: - CharacterTableViewCell
final class CharacterTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<CharacterCellView>?

    // converting SwiftUI View (CharacterCellView) to UITableViewCell to be dispalyed in tableView
    func configure(with character: CharacterModel) {
        let swiftUIView = CharacterCellView(character: character)
        
        if hostingController == nil {
            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.backgroundColor = .clear
            contentView.addSubview(hostingController.view)
            
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
            self.hostingController = hostingController
        } else {
            hostingController?.rootView = swiftUIView
        }
    }
}
