//
//  SignUpViewModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {

    enum SignUpViewState {
        case loading
        case loaded
        case loadingError(Error)
    }

    struct Form {
        var name: String
        var email: String
        var phone: String
        var positionId: Int?
        var inputImage: UIImage?
        var nameValidationMessage: String?
        var emailValidationMessage: String?
        var phoneValidationMessage: String?
        var imageValid: Bool
        var showingImagePicker: Bool

        static var empty: Self {
            .init(
                name: "",
                email: "",
                phone: "",
                positionId: nil,
                inputImage: nil,
                nameValidationMessage: nil,
                emailValidationMessage: nil,
                phoneValidationMessage: nil,
                imageValid: true,
                showingImagePicker: false
            )
        }
    }

    @Published var viewState: SignUpViewState
    @Published var form: Form
    @Published var positions = [Position]()

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewState = .loaded
        self.form = .empty
    }

    private func vaidateUserInput() -> Bool {
        var isValid = true
        form.nameValidationMessage = nil
        if form.name.isEmpty {
            form.nameValidationMessage = "Required field"
            isValid = false
        }

        form.emailValidationMessage = nil
        if form.email.isEmpty {
            form.emailValidationMessage = "Required field"
            isValid = false
        } else if !form.email.isValidEmail {
            form.emailValidationMessage = "Invalid email format"
            isValid = false
        }

        // TODO: Add other validations
        return isValid
    }

    func getPositions() {
        Task {
            do {
                let response = try await networkManager.getPositions()
                await MainActor.run {
                    self.positions = response.positions
                    if let postion = response.positions.first {
                        self.form.positionId = postion.id
                    } else {
                        self.form.positionId = nil
                    }
                    print(self.positions)
                }
            } catch {
                await MainActor.run {
                    // TODO: Handle error
                }
            }
        }
    }

    func createUser() {
        guard vaidateUserInput() else { return }
//        self.viewState = .loading
//        Task {
//            do {
//                let token = try await networkManager.getTokenString()
//                print("Token is: \(token)")
//                try await networkManager.createUser(user: user)
//                self.viewState = .loaded
//            } catch {
//                self.viewState = .loadingError(error)
//            }
//        }
    }
}
