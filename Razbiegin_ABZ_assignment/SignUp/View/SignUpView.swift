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
    @State var position: Int?

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        FieldsView()
    }
}

struct FieldsView: View {

    var body: some View {
        VStack {
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Your name",
                          validationHint: "",
                          keyboardType: .default)
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Email",
                          validationHint: "",
                          keyboardType: .emailAddress)
            TextFieldView(text: "",
                          valid: true,
                          placeholderText: "Phone",
                          validationHint: PhoneFormatter.formatPhone(number: "+38XXXXXXXXXX"),
                          keyboardType: .phonePad)
        }
    }
}

struct PhoneFormatter {

    static func formatPhone(number: String) -> String {
        let formatted = "\(number[0...2]) (\(number[3...5])) \(number[6...8]) - \(number[9...10]) - \(number[11...12])"
        print(formatted)
        return formatted
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
