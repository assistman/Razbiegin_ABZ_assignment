//
//  SignUpView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        self.viewModel.getPositions()
    }

    var body: some View {
        NavigationView {
            VStack {
                HeaderView(text: "Working with POST request")
                ScrollView {
                    VStack(alignment: .center) {
                        FieldsView()
                            .padding(.top, 16)
                        HStack {
                            Text("Select your position").font(.title2).padding(.top, 8)
                            Spacer()
                        }.padding(.horizontal)
                        switch viewModel.viewState.positionsSource {
                            case .loading:
                                ProgressView()
                            case .loaded(let positions):
                                HStack {
                                    RadioButtons(
                                        selectedId: $viewModel.viewState.positionId,
                                        positions: positions
                                    )
                                    .padding(.horizontal)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            case .loadingError:
                                    ResultView.noConnection(
                                        action: { viewModel.getPositions() }
                                    )
                        }
                        PhotoView(
                            image: $viewModel.viewState.inputImage,
                            valid: $viewModel.viewState.imageValid,
                            action: {
                                viewModel.viewState.showingImagePicker = true
                            }
                        )
                        Spacer()
                        Button(action: {
                            viewModel.createUser()
                        }) {
                            Text("SignUp").padding(.vertical).padding(.horizontal, 40)
                                .foregroundColor(.black)
                        }
                        .background(Color("normal"))
                        .clipShape(Capsule())
                    }.padding(.vertical)
                }
            }

        }.onChange(of: viewModel.viewState.inputImage, perform: {_ in
            print("Image data has been changed!")
        })
        .sheet(isPresented: $viewModel.viewState.showingImagePicker) {
            ImagePicker(image: $viewModel.viewState.inputImage)
        }
    }

    func FieldsView() -> some View {
        VStack(alignment: .leading) {
            TextFieldView(
                text: $viewModel.viewState.name,
                validationMessage: $viewModel.viewState.nameValidationMessage ,
                placeholderText: "Your name",
                keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.viewState.email,
                validationMessage: $viewModel.viewState.emailValidationMessage,
                placeholderText: "Email",
                keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.viewState.phone,
                validationMessage: $viewModel.viewState.phoneValidationMessage,
                placeholderText: "Phone",
                keyboardType: .phonePad)
            .padding(.horizontal, 16)
        }
    }
}
