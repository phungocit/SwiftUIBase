//
//  UsersViewModel.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import Foundation
import SwiftUIBase

final class UsersViewModel: ObservableObject {
    @Published var users = [UserModel]()

    @MainActor
    func getUsers() async {
        do {
            let usersReturned = try await APIService.shared.getUsers(APIService.GetUsersInput())
            users = usersReturned
        } catch {}
    }
}
