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
    @Binding var valid: Bool

    var placeholderText: String
    var validationHint: String?
    var emptyTextHint: String = "Required Field"
    var invalidFormatHint: String?
    var keyboardType: UIKeyboardType

    var noteColor: Color {
        valid ? Color("darkGray") : Color("error")
    }
    var borderColor: Color {
        valid ? Color("disabled") : Color("error")
    }

    var hint: String {
        if valid {
            return validationHint ?? " "
        }
        if text.isEmpty {
            return emptyTextHint
        }
        if let invalidFormatHint = invalidFormatHint {
            return invalidFormatHint
        }
        return " "
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                if valid || text.isEmpty {
                    TextField("", text: $text, prompt: Text(placeholderText)
                        .foregroundColor(noteColor)
                        .font(.headline)
                    )
                        .font(.headline)
                        .keyboardType(keyboardType)
                        .onSubmit {
                            // Field validation should be done onSubmit
                        }
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
                        .onSubmit {
                            // Field validation should be done onSubmit
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 60)
            .roundedBorder(color: borderColor, cornerRadius: 3.0)

            Text(hint)
                .font(.footnote)
                .foregroundColor(noteColor)
        }
    }
}
