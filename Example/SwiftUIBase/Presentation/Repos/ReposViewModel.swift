//
//  ReposViewModel.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import Foundation
import SwiftUIBase

@MainActor
final class ReposViewModel: ObservableObject {
    @Published var repos = [RepoModel]()

    func getRepos() async {
        do {
            let repoReturned = try await APIService.shared.getRepos(
                APIService.GetReposInput(getPageModel: GetPageModel(page: 1, perPage: 30))
            )
            repos = repoReturned.repos ?? []
        } catch {}
    }
}
