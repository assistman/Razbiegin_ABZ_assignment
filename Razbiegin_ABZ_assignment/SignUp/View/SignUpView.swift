//
//  SignUpView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

// TODO: Place SignUP view here
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
        Text("Signup user screen ;)")
        TextField("Your name", text: $name)
        TextField("Email", text: $email)
        TextField("Phone", text: $phone)
    }
}
