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
        HeaderView()
            .frame(maxWidth: .infinity)
        ZStack {
            switch viewModel.viewState {
                case .loaded(let users):
                    loadedView(users: users)
                default:
                    Text("No users")
            }
        }
    }

    func loadedView(users: [User]) -> some View {
        List {
            ForEach(users) { user in
                UserView(user: user)
            }
        }
    }
}

struct HeaderView: View {

    var body: some View {
        Text("Working with GET request")
            .font(.headline)
        .background(Color(hex: "F4E041"))
    }
}

struct UserView: View {
    var user: User

    var body: some View {
        HStack {
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

struct EmailAddressView: View {
    var emailAddress: String

    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(emailAddress)
        }
    }
}

struct PhoneView: View {
    var phone: String

    var body: some View {
        HStack {
            Text(phone)
        }
    }
}

struct UserDetailsView: View {
    var user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.title)
                .foregroundStyle(.primary)
            Text(user.position)
                .foregroundStyle(.secondary)
            EmailAddressView(emailAddress: user.email) // Consider removing extra view wrappers
            PhoneView(phone: user.phone)
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
