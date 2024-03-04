//
//  RepoModel.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

struct RepoModel: Codable {
    let id: Int?
    let name: String?
    let fullname: String?
    let urlString: String?
    let starCount: Int?
    let folkCount: Int?
    let owner: OwnerModel?
}

extension RepoModel {
    struct OwnerModel: Codable {
        let avatarUrl: String?

        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, name
        case fullname = "full_name"
        case urlString = "html_url"
        case starCount = "stargazers_count"
        case folkCount = "forks"
        case owner
    }
}
