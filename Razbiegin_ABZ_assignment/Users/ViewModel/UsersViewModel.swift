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
    }

    func getUsers() {
        self.viewState = .loading
        networkManager.getUsers { [weak self] result in
            switch result {
                case .success(let response):
                    self?.viewState = .loaded(response.users)
                case .failure(let error):
                    print(error)
                    self?.viewState = .loadingError(error)
                    // handle error
            }
        }
    }
}
