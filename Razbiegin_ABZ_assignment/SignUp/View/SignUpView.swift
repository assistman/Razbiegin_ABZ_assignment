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
//                            RadioButtons(selected: $viewModel.form.position, positions: ["Frontend developer", "Backend developer", "Designer", "QA"])
//                                .padding(.horizontal)
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
            TextFieldView(text: $viewModel.form.name,
                          validationMessage: $viewModel.form.nameValidationMessage ,
                          placeholderText: "Your name",
                          keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(text: $viewModel.form.email,
                          validationMessage: $viewModel.form.emailValidationMessage,
                          placeholderText: "Email",
                          keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(text: $viewModel.form.phone,
                          validationMessage: $viewModel.form.phoneValidationMessage,
                          placeholderText: "Phone",
                          keyboardType: .phonePad)
            .padding(.horizontal, 16)
        }
    }
}

struct PhotoView: View {

    @Binding var image: UIImage?
    @Binding var valid: Bool

    var action: (() -> Void)?
    var uploadHint: String = "Upload your photo"
    var uploadButtonString: String = "Upload"
    var noPhotoHint: String = "Photo is required"

    var noteColor: Color {
        valid ? Color.gray : Color("error")
    }

    var body: some View {
        VStack{
            HStack {
                Text(uploadHint)
                    .font(.headline)
                    .foregroundColor(noteColor)
                    .padding()
                Button {
                    action?()
                } label: {
                    Text(uploadButtonString)
                        .font(.headline)
                        .foregroundColor(.cyan)
                }.padding()

            }
            .frame(height: 60)
            .roundedBorder(color: noteColor, cornerRadius: 3.0)
            Text(valid ? " " : noPhotoHint)
                .font(.footnote)
                .foregroundColor(noteColor)
        }
    }
}

struct RadioButtons: View {

    @Binding var selected: String
    var positions: [String]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(positions,id: \.self) {i in
                Button(action: {
                    self.selected = i
                }) {
                    HStack {
                        ZStack {
                            if self.selected == i {
                                Circle()
                                    .stroke(Color("radio_button_selected"), lineWidth: 5)
                                    .frame(width: 14, height: 14)
                            } else {
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 14, height: 14)
                            }
                        }
                        Text(i)
                            .padding(.horizontal)
                    }.foregroundColor(.black)
                }.padding(.top, 8)
            }
        }
    }
}
