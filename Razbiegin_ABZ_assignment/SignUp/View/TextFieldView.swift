//
//  TextFieldView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 25.02.2025.
//

import Foundation
import SwiftUI

struct TextFieldView: View {

    @Binding var text: String
    @Binding var validationMessage: String?

    var placeholderText: String
    var keyboardType: UIKeyboardType

    var isValid: Bool {
        return validationMessage == nil
    }

    var noteColor: Color {
        isValid ? Color("darkGray") : Color("error")
    }
    var borderColor: Color {
        isValid ? Color("disabled") : Color("error")
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                if text.isEmpty {
                    TextField("", text: $text, prompt: Text(placeholderText)
                        .foregroundColor(noteColor)
                        .font(.headline)
                    ).onReceive(text.publisher) { _ in
                        validationMessage = nil
                    }
                        .font(.headline)
                        .keyboardType(keyboardType)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                } else {
                    Text(placeholderText)
                        .foregroundColor(noteColor)
                        .font(.footnote)
                        .padding(.horizontal)
                    TextField("", text: $text)
                        .textFieldStyle(.plain)
                        .font(.subheadline)
                        .keyboardType(keyboardType)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 60)
            .roundedBorder(color: borderColor, cornerRadius: 3.0)

            Text(validationMessage ?? "")
                .font(.footnote)
                .foregroundColor(noteColor)
        }
    }
}
