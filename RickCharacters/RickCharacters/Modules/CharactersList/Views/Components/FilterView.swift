//
//  FilterView.swift
//  RickCharacters
//
//  Created by Mostafa AbdElAal, Vodafone on 08/01/2025.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: CharactersListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "Alive",
                    isSelected: viewModel.selectedStatus == .alive,
                    selectedStatus: .alive,
                    action: { viewModel.filterCharacters(by: .alive) }
                )
                
                FilterButton(
                    title: "Dead",
                    isSelected: viewModel.selectedStatus == .dead,
                    selectedStatus: .dead,
                    action: { viewModel.filterCharacters(by: .dead) }
                )
                
                FilterButton(
                    title: "Unknown",
                    isSelected: viewModel.selectedStatus == .unknown,
                    selectedStatus: .unknown,
                    action: { viewModel.filterCharacters(by: .unknown) }
                )
            }
            .padding(.horizontal)
        }
        .scrollDisabled(true)
    }
}

#Preview {
    FilterView(viewModel: CharactersListViewModel(charactersListRepository: CharactersListRepository()))
}

private struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let selectedStatus: Status
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .foregroundStyle(
                    isSelected && selectedStatus == .alive ? Color(.label).opacity(0.7) :
                        isSelected && selectedStatus == .dead ? Color.pink.opacity(0.4) :
                        isSelected && selectedStatus == .unknown ? Color.blue.opacity(0.5) :
                        Color(.label)
                )
                .background(
                    Capsule()
                        .stroke(Color.primary.opacity(!isSelected ? 0.3 : 0.0), lineWidth: 1)
                        .background(
                            isSelected && selectedStatus == .alive ? Color.gray.opacity(0.4) :
                                isSelected && selectedStatus == .dead ? Color.pink.opacity(0.2) :
                                isSelected && selectedStatus == .unknown ? Color.blue.opacity(0.2) :
                                Color(.systemBackground)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}
