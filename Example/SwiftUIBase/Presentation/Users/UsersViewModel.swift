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
    @Published var isShowLoading = false

    private var disposables = Set<AnyCancellable>()

    init() {
        isShowLoading = true
        getUsers()
    }

    func getUsers() {
        APIService.shared.getUsers(APIService.GetUsersInput())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.isShowLoading = false
            } receiveValue: { [unowned self] usersReturned in
                self.users = usersReturned
            }
            .store(in: &disposables)
    }
}
