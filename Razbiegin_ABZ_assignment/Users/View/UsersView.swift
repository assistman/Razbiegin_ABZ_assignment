//
//  UsersView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

// TODO: Place Users view here
struct UsersView: View {

    @State var viewModel: UsersViewModel

    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("Hello ;)")
    }
}
