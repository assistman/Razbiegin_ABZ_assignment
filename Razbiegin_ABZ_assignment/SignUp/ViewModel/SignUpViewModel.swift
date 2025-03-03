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

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var position: Int?
    @Published var inputImage: UIImage?
    
    @Published var nameValid: Bool = true
    @Published var emailValid: Bool = true
    @Published var phoneValid: Bool = true
    @Published var positionValid: Bool = true
    @Published var imageValid: Bool = true

    private var cancellables = Set<AnyCancellable>()

    var isFormValid: Bool {
        return nameValid &&
        emailValid &&
        phoneValid &&
        imageValid &&
        !name.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        position != nil &&
        inputImage != nil
    }

    enum SignUpViewState {
        case loading
        case loaded
        case loadingError(Error)
    }

    @Published var viewState: SignUpViewState

    var networkManager: NetworkManager

    init(manager: NetworkManager) {
        self.networkManager = manager
        self.viewState = .loaded

        $name
            .dropFirst()
            .sink { [weak self] value in
                self?.nameValid = value.isEmpty ? false : true
            }
            .store(in: &cancellables)

        $email
            .dropFirst()
            .sink { [weak self] value in
                self?.emailValid = self?.isValidEmail(value) ?? false
            }
            .store(in: &cancellables)

        $phone
            .dropFirst()
            .sink { [weak self] value in
                self?.phoneValid = self?.isValidPhone(value) ?? false
            }
            .store(in: &cancellables)
        $position
            .dropFirst()
            .sink { [weak self] value in
                self?.positionValid = self?.position != nil ? true : false
            }
            .store(in: &cancellables)
        $inputImage
            .dropFirst()
            .sink { [weak self] value in
                self?.imageValid = self?.inputImage != nil ? true : false
            }
            .store(in: &cancellables)
    }

    func validateEmail() {
        emailValid = isValidEmail(email)
    }

    func validatePhone() {
        phoneValid = isValidPhone(phone)
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Simple regexp for test assignment purposes
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPhone(_ phone: String) -> Bool {
        return phone.starts(with: "+380") && phone.count == 13
    }

    func createUserInput() -> SignUpUserParam? {
        guard let imageData = inputImage?.jpegData(compressionQuality: 0.8) else {
            // Add validation
            print("No image selected\n")
            return nil
        }
        let imageDataString = imageData.base64EncodedString()

        let userParam = SignUpUserParam(name: name, email: email, phone: phone, position_id: position ?? 1, photo: imageDataString)
        return userParam
    }

    func validateUserInput(_ userInput: SignUpUserParam) -> Bool {
        
        return false
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
