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

    enum PositionsSource {
        case loading
        case loaded([Position])
        case loadingError
    }

    enum SignUpViewState {
        case loading
        case loaded
        case loadingError(Error)
    }

    struct ViewState {
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

        var positionsSource: PositionsSource

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
                showingImagePicker: false,
                positionsSource: .loading
            )
        }
    }

    @Published var viewState: ViewState
    @Published var positions = [Position]()

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewState = .empty
    }

    private func vaidateUserInput() -> Bool {
        var isValid = true
        viewState.nameValidationMessage = nil
        if viewState.name.isEmpty {
            viewState.nameValidationMessage = "Required field"
            isValid = false
        }

        viewState.emailValidationMessage = nil
        if viewState.email.isEmpty {
            viewState.emailValidationMessage = "Required field"
            isValid = false
        } else if !viewState.email.isValidEmail {
            viewState.emailValidationMessage = "Invalid email format"
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
                    let positions = response.positions
                    print(positions)
                    self.viewState.positionsSource = .loaded(positions)
                }
            } catch {
                await MainActor.run {
                    self.viewState.positionsSource = .loadingError
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
