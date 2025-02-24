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
            switch viewModel.viewState {
                case .loaded(let content):
                    loadedView(content: content)
                default:
                    Text("No users")
            }
        }
        .fullScreenCover(isPresented: .constant(viewModel.viewState.isError)) {
            ResultView(
                imageName: "no_connection",
                text: "There is no internet connection",
                buttonTitle: "Try again",
                action: { viewModel.getUsers() }
            )
        }
    }

    func loadedView(
        content: UsersViewModel.ViewState.LoadedContent
    ) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(content.users) { user in
                    UserView(user: user)
                        .padding(.horizontal, 16)
                }
                if content.canLoadMore {
                    LoadingNextPageView().onAppear {
                        viewModel.getUsers()
                    }
                }
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

struct LoadingNextPageView: View {

    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding(16)
            .frame(maxWidth: .infinity)
    }
}

struct SheetView: View {
   @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
           Button {
              dismiss()
           } label: {
               Image(systemName: "xmark.circle")
                 .font(.largeTitle)
                 .foregroundColor(.gray)
           }
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
         .padding()
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
        UsersView(viewModel: UsersViewModel(
            manager: NetworkManager()
        ))
    }
}
