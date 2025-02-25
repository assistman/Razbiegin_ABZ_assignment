//
//  SignUpView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//
// just checking the broken github account settings
import Foundation
import SwiftUI

struct SignUpView: View {

    @State var viewModel: SignUpViewModel
    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var position: Int?
    @State var selected = ""
    @State var inputImage: UIImage?
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
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Select image")
                }
                Spacer()
                Button(action: {
                    // Make Sign Up
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
}

struct FieldsView: View {

    var body: some View {
        VStack(alignment: .leading) {
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Your name",
                          validationHint: "",
                          keyboardType: .default)
            .padding(.horizontal, 16)
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Email",
                          validationHint: "",
                          keyboardType: .emailAddress)
            .padding(.horizontal, 16)
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Phone",
                          validationHint: PhoneFormatter.formatPhone(number: "+38XXXXXXXXXX"),
                          keyboardType: .phonePad)
            .padding(.horizontal, 16)
        }
    }
}

struct TextFieldView: View {

    @State var text: String
    @State var valid: Bool

    var placeholderText: String
    var validationHint: String
    var keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholderText, text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(.roundedBorder)
            Text(validationHint)
                .foregroundColor( valid ? Color.gray : Color("error"))
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
