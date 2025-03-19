//
//  TextFieldView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 25.02.2025.
//

import Foundation
import SwiftUI

struct TextFieldView: View {
    enum TextFieldViewFocusState: Hashable, CaseIterable {
        case largeTextField
        case smallTextField
    }
    
    @Binding var text: String
    @Binding var validationMessage: String?
    
    @FocusState var focusState: TextFieldViewFocusState?

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
                    .onAppear() {
                        if focusState == .smallTextField {
                            focusState = .largeTextField
                        }
                    }
                        .focused($focusState, equals: .largeTextField)
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
                        .onAppear() {
                            if focusState == .largeTextField {
                                focusState = .smallTextField
                            }
                        }
                        .focused($focusState, equals: .smallTextField)
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
