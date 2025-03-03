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
                        HStack {
                            RadioButtons(
                                selected: $viewModel.form.positionId,
                                positions: $viewModel.positions)
                                .padding(.horizontal)
                            Spacer()
                        }
                        PhotoView(
                            image: $viewModel.form.inputImage,
                            valid: $viewModel.form.imageValid,
                            action: {
                                viewModel.form.showingImagePicker = true
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

        }.onChange(of: viewModel.form.inputImage, perform: {_ in
            print("Image data has been changed!")
        })
        .sheet(isPresented: $viewModel.form.showingImagePicker) {
            ImagePicker(image: $viewModel.form.inputImage)
        }
    }

    func FieldsView() -> some View {
        VStack(alignment: .leading) {
            TextFieldView(
                text: $viewModel.form.name,
                validationMessage: $viewModel.form.nameValidationMessage ,
                placeholderText: "Your name",
                keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.form.email,
                validationMessage: $viewModel.form.emailValidationMessage,
                placeholderText: "Email",
                keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(
                text: $viewModel.form.phone,
                validationMessage: $viewModel.form.phoneValidationMessage,
                placeholderText: "Phone",
                keyboardType: .phonePad)
            .padding(.horizontal, 16)
        }
    }
}
