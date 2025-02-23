//
//  UsersView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

struct UsersView: View {

    @ObservedObject var viewModel: UsersViewModel

    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        VStack {
            HeaderView()
                .background(Color("normal"))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
            switch viewModel.viewState {
                case .loaded(let users):
                    loadedView(users: users)
                default:
                    EmptyView()
            }
        }
    }

    func loadedView(users: [User]) -> some View {
        List {
            ForEach(users) { user in
                UserView(user: user)
            }
        }
        .listStyle(.plain)
        .frame(maxWidth: .infinity)

    }
}

struct HeaderView: View {

    var body: some View {
        Text("Working with GET request")
            .font(.headline)
            .padding(16)
    }
}

struct EmptyView: View {

    var body: some View {
        VStack {
            Image("success-image")
            Text("There are no users yet")
                .font(.title)
        }
    }
}

struct UserView: View {
    var user: User

    var body: some View {
        HStack(alignment: .top) {
            ProfilePicture(imageUrl: user.photo)
            UserDetailsView(user: user)
        }
    }
}

struct ProfilePicture: View {
    var imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
                case .success(let image):
                    image.resizable()
                case .failure:
                    Image(systemName: "photo").font(.largeTitle)
                default: ProgressView()
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }
}

struct UserDetailsView: View {
    var user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.title)
            Text(user.position)
                .foregroundStyle(.secondary)
                .padding(4)
            Text(user.email)
                .padding(4)
            Text(user.phone)
                .padding(4)
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(viewModel: UsersViewModel(manager: NetworkManager()))
    }
}
