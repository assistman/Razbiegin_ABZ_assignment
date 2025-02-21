//
//  SignUpViewModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation

// TODO: Place SignUP related logic here
class SignUpViewModel {

    enum SignUpViewState {
        case loading
        case loaded
        case loadingError(Error)
    }

    @Published var viewState: SignUpViewState

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewState = .loading
    }

    func createUser(user: SignUpUserParam) {
        self.viewState = .loading
//        self.networkManager.createUser(user: user) { [weak self] result in
//            switch(result) {
//                case .success(_):
//                    self?.viewState = .loaded
//                case .failure(let error):
//                    self?.viewState = .loadingError(error)
//            }
//        }
    }
}
