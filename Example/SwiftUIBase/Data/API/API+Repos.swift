//
//  APIService+Repos.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import SwiftUIBase

// MARK: - GetRepos
extension APIService {
    func getRepos(_ input: GetReposInput) -> Observable<GetReposOutput> {
        request(input)
    }
}

// MARK: - Repos Input
extension APIService {
    struct ReposParameters: Encodable {
        let query: String
        let perPage: Int
        let page: Int

        private enum CodingKeys: String, CodingKey {
            case query = "q"
            case perPage
            case page
        }
    }

    final class GetReposInput: APIInput<ReposParameters> {
        init(getPageModel: GetPageModel) {
            super.init(
                urlString: APIService.Urls.getRepos,
                method: .get,
                parameters: ReposParameters(
                    query: "language:swift",
                    perPage: getPageModel.perPage,
                    page: getPageModel.page
                )
            )

            keyDecodingStrategy = .useDefaultKeys
        }
    }
}

// MARK: - Repos Output
extension APIService {
    struct GetReposOutput: Codable {
        let repos: [RepoModel]?
        let totalCount: Int?

        private enum CodingKeys: String, CodingKey {
            case totalCount
            case repos = "items"
        }
    }
}
