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
        let user = SignUpUserParam(name: "John", email: "email@razbegin.com", phone: "+380964034443", position_id: 1, photo: "")
        createUser(user: user)
    }

    func createUser(user: SignUpUserParam) {
        self.viewState = .loading
        Task {
            do {
                let token = try await networkManager.getToken()
                print("Token is: \(token.token)")
                try await networkManager.createUser(user: user)
                self.viewState = .loaded
            } catch {
                self.viewState = .loadingError(error)
            }
        }
    }
}
