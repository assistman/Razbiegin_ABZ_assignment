//
//  SignUpViewModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import UIKit

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
        let image = UIImage(named: "imagetest")
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let imageDataString = imageData.base64EncodedString()
        print(imageDataString)
        let user = SignUpUserParam(name: "John", email: "email@razbegin.com", phone: "+380964034443", position_id: 1, photo: imageDataString)
        createUser(user: user)
    }

    func createUser(user: SignUpUserParam) {
        self.viewState = .loading
        Task {
            do {
                let token = try await networkManager.getTokenString()
                print("Token is: \(token)")
                try await networkManager.createUser(user: user)
                self.viewState = .loaded
            } catch {
                self.viewState = .loadingError(error)
            }
        }
    }
}
