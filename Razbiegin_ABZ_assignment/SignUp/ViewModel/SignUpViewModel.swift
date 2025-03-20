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

    struct ViewContent {

        enum State {
            case active
            case inProgress
            case noConnection
            case result(imageName: String, message: String, buttonTitle: String)

            var needsCoverView: Bool {
                switch self {
                case .active:
                    return false
                default: return true
                }
            }
        }

        var state: State
        var name: String
        var email: String
        var phone: String
        var positionId: Int?
        var inputImage: UIImage?
        var nameValidationMessage: String?
        var emailValidationMessage: String?
        var phoneValidationMessage: String?
        var photoValidationMessage: String?
        var imageValid: Bool
        var showingImagePicker: Bool
        var positionsSource: PositionsSource

        static var empty: Self {
            .init(
                state: .active,
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

    @Published var viewContent: ViewContent
    @Published var positions = [Position]()

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewContent = .empty
        // Tmp, just for debug
        prefillUser()
    }

    private func vaidateUserInput() -> SignUpUserParameters? {
        var isValid = true
        viewContent.nameValidationMessage = nil
        if viewContent.name.isEmpty {
            viewContent.nameValidationMessage = "Required field"
            isValid = false
        }

        viewContent.emailValidationMessage = nil
        if viewContent.email.isEmpty {
            viewContent.emailValidationMessage = "Required field"
            isValid = false
        } else if !viewContent.email.isValidEmail {
            viewContent.emailValidationMessage = "Invalid email format"
            isValid = false
        }

        // TODO: Add other validations

        guard let image = viewContent.inputImage,
              let imageData = image.jpegData(compressionQuality: 0.8)
        else {
            viewContent.photoValidationMessage = "Photo is required"
            return nil
        }
        if !isValid {
            return nil
        }
        return .init(
            name: viewContent.name,
            email: viewContent.email,
            phone: viewContent.phone,
            positionId: viewContent.positionId ?? 0,
            photo: imageData
        )
    }

    func getPositions() {
        Task {
            do {
                let response = try await networkManager.getPositions()
                await MainActor.run {
                    let positions = response.positions
                    print(positions)
                    self.viewContent.positionsSource = .loaded(positions)
                }
            } catch {
                await MainActor.run {
                    self.viewContent.positionsSource = .loadingError
                }
            }
        }
    }

    // Tmp, just for debug
    func prefillUser() {
        let rnd = Int.random(in: 1000...10000)
        let img = UIImage(named: "no_connection")!
        viewContent.name = "User\(rnd)"
        viewContent.email = "user\(rnd)@mail.com"
        viewContent.phone = "+38012345\(rnd)"
    }

    func signUp() {
        guard let userParams = vaidateUserInput() else { return }
        self.viewContent.state = .inProgress
        Task {
            do {
                let token = try await networkManager.getTokenString()
                print("Token is: \(token)")
                let response = try await networkManager.signUpUser(parameters: userParams)
                print("Response: \(response)")
                await MainActor.run {
                    switch response {
                    case .success:
                        self.viewContent.state = .result(
                            imageName: "signup_success",
                            message: "User successfully registered",
                            buttonTitle: "Got it"
                        )
                    case .failure(let reason):
                        self.viewContent.state = .result(
                            imageName: "signup_failure",
                            message: reason,
                            buttonTitle: "Try again"
                        )
                    }
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    // Other types of errors are not handled.
                    // In real app there should be some general error handling
                    // for all unexpected errors.
                    self.viewContent.state = .noConnection
                }
            }
        }
    }
}
