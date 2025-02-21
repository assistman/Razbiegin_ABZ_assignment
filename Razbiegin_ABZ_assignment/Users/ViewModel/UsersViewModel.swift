//
//  UsersViewModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

class UsersViewModel {

    enum UsersViewState {
        case loaded([User])
        case loading
        case loadingError(Error)
    }

    @Published var viewState: UsersViewState

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewState = .loading
        getUsers()
    }

    func getUsers() {
        self.viewState = .loading
        Task {
            do {
                let response = try await networkManager.getUsers(page: 1, count: 5)
                self.viewState = .loaded(response.users)
            } catch {
                self.viewState = .loadingError(error)
            }
        }
    }
}
