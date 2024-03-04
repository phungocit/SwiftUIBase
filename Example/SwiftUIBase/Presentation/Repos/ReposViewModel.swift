//
//  ReposViewModel.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import Foundation
import SwiftUIBase

final class ReposViewModel: ObservableObject {
    @Published var repos = [RepoModel]()
    @Published var isShowLoading = false

    private var disposables = Set<AnyCancellable>()

    init() {
        isShowLoading = true
        getRepos()
    }

    func getRepos() {
        APIService.shared.getRepos(
            APIService.GetReposInput(getPageModel: GetPageModel(page: 1, perPage: 30))
        )
        .receive(on: DispatchQueue.main)
        .sink { [unowned self] _ in
            self.isShowLoading = false
        } receiveValue: { [unowned self] repoReturned in
            self.repos = repoReturned.repos ?? []
        }
        .store(in: &disposables)
    }
}
