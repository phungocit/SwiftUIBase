//
//  ReposView.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import SwiftUI
import SwiftUIBase

struct ReposView: View {
    @StateObject private var viewModel = ReposViewModel()
    @State private var isShowLoading = false
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.repos, id: \.id) { repo in
                    repoItem(repo: repo)
                }
            }
            .padding()
        }
        .loadingView(isShowing: $isShowLoading)
        .navigationTitle("Repos")
        .task {
            isShowLoading = true
            await viewModel.getRepos()
            isShowLoading = false
        }
    }

    func repoItem(repo: RepoModel) -> some View {
        HStack(spacing: 12) {
            if let url = URL(string: repo.owner?.avatarUrl ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
            }
            if let urlString = repo.urlString, let destination = URL(string: urlString) {
                Link(repo.name ?? "", destination: destination)
            }
            if let starCount = repo.starCount {
                Spacer()
                HStack(spacing: 2) {
                    Text("\(starCount)")
                        .font(.callout)
                    Image(systemName: "star.fill")
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    ReposView()
}
