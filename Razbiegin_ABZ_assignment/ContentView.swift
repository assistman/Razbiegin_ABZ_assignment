//
//  ContentView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            UsersView(viewModel: UsersViewModel(manager: NetworkManager()))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
