//
//  PhotoView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 03.03.2025.
//

import Foundation
import SwiftUI

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
