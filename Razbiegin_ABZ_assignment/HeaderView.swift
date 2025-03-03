//
//  HeaderView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 24.02.2025.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color("normal"))
    }
}
