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
//        .background(Color(hex: "F4E041"))

    var body: some View {
        VStack {
            HeaderView()
            ZStack {
                switch viewModel.viewState {
                    case .loaded(let content):
                        loadedView(content: content)
                    default:
                        Text("No users")
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
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
            LazyVStack {
                ForEach(content.users) { user in
                    UserView(user: user)
                }
                if content.canLoadMore {
                    LoadingNextPageView().onAppear {
                        viewModel.getUsers()
                    }
                }
            }
        }
    }
}

struct HeaderView: View {

    var body: some View {
        Text("Working with GET request")
            .font(.headline)
            .padding(16)
//            .background(Color(hex: "F4E041"))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 56)
            .background(Color(hex: "F4E041"))
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

// Just a convenient hex initializer for Color. Should be moved somewhere..
extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(viewModel: UsersViewModel(
            manager: NetworkManager()
        ))
    }
}
