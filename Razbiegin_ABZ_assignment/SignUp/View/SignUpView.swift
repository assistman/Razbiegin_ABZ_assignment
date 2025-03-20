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
                        switch viewModel.viewContent.positionsSource {
                            case .loading:
                                ProgressView()
                            case .loaded(let positions):
                                HStack {
                                    RadioButtons(
                                        selectedId: $viewModel.viewContent.positionId,
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
                            image: $viewModel.viewContent.inputImage,
                            errorMessage: viewModel.viewContent.photoValidationMessage,
                            action: {
                                viewModel.viewContent.showingImagePicker = true
                            }
                        )
                        Spacer()
                        Button(action: {
                            viewModel.signUp()
                        }) {
                            Text("SignUp").padding(.vertical).padding(.horizontal, 40)
                                .foregroundColor(.black)
                        }
                        .background(Color("normal"))
                        .clipShape(Capsule())
                    }.padding(.vertical)
                }
                .fullScreenCover(
                    isPresented: .constant(viewModel.viewContent.state.needsCoverView)) {
                    ZStack {
                        switch viewModel.viewContent.state {
                        case .noConnection:
                            ResultView.noConnection(
                                action: { viewModel.viewContent.state = .active }
                            )
                        case .result(let imageName, let message, let buttonTitle):
                            ResultView(
                                imageName: imageName,
                                text: message,
                                buttonTitle: buttonTitle,
                                action: { viewModel.viewContent.state = .active }
                            )
                        case .inProgress:
                            ProgressView()
                        default:
                            EmptyView()
                        }
                    }
                }
            }

        }.onChange(of: viewModel.viewContent.inputImage, perform: {_ in
            print("Image data has been changed!")
        })
        .sheet(isPresented: $viewModel.viewContent.showingImagePicker) {
            ImagePicker(image: $viewModel.viewContent.inputImage)
        }
    }
    func FieldsView() -> some View {
        VStack(alignment: .leading) {
            TextFieldView(
                text: $viewModel.viewContent.name,
                validationMessage: $viewModel.viewContent.nameValidationMessage ,
                placeholderText: "Your name",
                keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.viewContent.email,
                validationMessage: $viewModel.viewContent.emailValidationMessage,
                placeholderText: "Email",
                keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.viewContent.phone,
                validationMessage: $viewModel.viewContent.phoneValidationMessage,
                placeholderText: "Phone",
                keyboardType: .phonePad)
            .padding(.horizontal, 16)
        }
    }
}
