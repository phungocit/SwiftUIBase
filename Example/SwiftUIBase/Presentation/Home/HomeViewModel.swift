//
//  HomeViewModel.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import Foundation
import SwiftUIBase

final class HomeViewModel: ObservableObject {
    @Published var menuSections = [
        MenuSection(title: "API", menus: [.users, .repos]),
    ]
}

extension HomeViewModel {
    enum Menu: Int, CustomStringConvertible, CaseIterable {
        case users
        case repos

        var description: String {
            switch self {
            case .users:
                return "Get user list"
            case .repos:
                return "Get repo list"
            }
        }
    }

    struct MenuSection: Identifiable {
        var id = UUID().uuidString
        let title: String
        let menus: [Menu]
    }
}
