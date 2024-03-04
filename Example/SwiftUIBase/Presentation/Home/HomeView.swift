//
//  HomeView.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import SwiftUI
import SwiftUIBase

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()

    var body: some View {
        List {
            ForEach(viewModel.menuSections, id: \.title) { section in
                Section {
                    ForEach(section.menus, id: \.self) { menu in
                        itemMenu(menu: menu)
                    }
                } header: {
                    Text(section.title)
                        .font(.callout)
                }
            }
        }
        .navigationTitle("Home")
    }

    func itemMenu(menu: HomeViewModel.Menu) -> some View {
        NavigationLink {
            switch menu {
            case .users:
                UsersView()
            case .repos:
                ReposView()
            }
        } label: {
            Text(menu.description)
                .font(.body)
        }
    }
}

#Preview {
    HomeView()
}
