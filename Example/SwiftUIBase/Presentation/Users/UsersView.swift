//
//  UsersView.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import SwiftUIBase
import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.users, id: \.id) { user in
                    userItem(user: user)
                }
            }
            .padding()
        }
        .loadingView(isShowing: $viewModel.isShowLoading)
        .navigationTitle("Users")
    }

    func userItem(user: UserModel) -> some View {
        HStack(spacing: 12) {
            if let url = URL(string: user.avatarUrl ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
            }
            if let htmlUrl = user.htmlUrl, let destination = URL(string: htmlUrl) {
                Link(user.login ?? "", destination: destination)
            }
        }
    }
}

#Preview {
    UsersView()
}
