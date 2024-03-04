//
//  API+Users.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import SwiftUIBase

// MARK: - GetUsers
extension APIService {
    func getUsers(_ input: GetUsersInput) -> Observable<[UserModel]> {
        request(input)
    }
}

// MARK: - Users Input
extension APIService {
    final class GetUsersInput: APIInput<Alamofire.Empty> {
        init() {
            super.init(
                urlString: APIService.Urls.getUsers,
                method: .get
            )
        }
    }
}
