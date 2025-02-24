//
//  ContentView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import SwiftUI

class ContentViewModel: ObservableObject {

    enum MainViewState {
        case loading
        case loaded
        case error
    }

    let networkManager = NetworkManager()

    @Published var viewState: MainViewState

    init(networkManager: NetworkManager) {
        viewState = .loading
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                self.viewState = .loaded
            }
        }
    }
}

struct ContentView: View {

    @ObservedObject
    var viewModel: ContentViewModel

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .loading:
                Image("Logo")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
            case .loaded:
                TabView {
                    UsersView(viewModel: UsersViewModel(
                        manager: viewModel.networkManager
                    ))
                    .tabItem {
                        Image(systemName: "person.3.sequence.fill")
                                .renderingMode(.template)
                        Text("Users")
                    }
                    .tag(0)
                    SignUpView(viewModel: SignUpViewModel(
                        manager: viewModel.networkManager
                    ))
                    .tabItem {
                        Text("Sign up")
                        Image(systemName: "person.crop.circle.badge.plus")
                            .renderingMode(.template)
                    }
                    .tag(1)
                }
            case .error: Text("Error!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(
            networkManager: NetworkManager()
        ))
    }
}
