//
//  ResultView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 2/24/25.
//

import Foundation
import SwiftUI

struct ResultView: View {
    let imageName: String
    let text: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(imageName)
            Button {
               action()
            } label: {
                Text(buttonTitle)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.yellow)
            )
            Text(text)
         }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color.white)
    }
}
