//
//  SignUpView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

struct SignUpView: View {

    @State var viewModel: SignUpViewModel
    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var nameValid: Bool = true
    @State var emailValid: Bool = true
    @State var phoneValid: Bool = true
    @State var position: Int?
    @State var selected = ""
    @State var inputImage: UIImage?
    @State var imageValid: Bool = true
    @State var showingImagePicker = false

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HeaderView(text: "Working with POST request")
                FieldsView()
                HStack {
                    Text("Select your position").font(.title2).padding(.top)
                    Spacer()
                }.padding(.horizontal)
                HStack {
                    RadioButtons(selected: $selected)
                        .padding(.horizontal)
                    Spacer()
                }
                PhotoView(
                    image: $inputImage,
                    valid: $imageValid,
                    action: {
                        showingImagePicker = true
                    }
                )
                Spacer()
                Button(action: {
                    nameValid.toggle()
                    emailValid.toggle()
                    phoneValid.toggle()
                }) {
                    Text("SignUp").padding(.vertical).padding(.horizontal, 40)
                        .foregroundColor(.black)
                }
                .background(Color("normal"))
                .clipShape(Capsule())

            }.padding(.vertical)
        }.onChange(of: inputImage, perform: {_ in
            print("Image data has been changed!")
        })
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }

    func FieldsView() -> some View {
        VStack(alignment: .leading) {
            TextFieldView(text: $name,
                          valid: $nameValid,
                          placeholderText: "Your name",
                          keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(text: $email,
                          valid: $emailValid,
                          placeholderText: "Email",
                          invalidFormatHint: "Invalid email format",
                          keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(text: $phone,
                          valid: $phoneValid,
                          placeholderText: "Phone",
                          validationHint: PhoneFormatter.formatPhone(number: "+38XXXXXXXXXX"),
                          invalidFormatHint: "Invalid phone format",
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
                Button {
                    action?()
                } label: {
                    Text(uploadButtonString)
                        .font(.headline)
                        .foregroundColor(.cyan)
                }

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

    var positions = ["Frontend developer", "Backend developer", "Designer", "QA"]
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
                }.padding(.top)
            }
        }.padding(.vertical)
    }
}
