//
//  UsersViewModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation
import SwiftUI

class UsersViewModel: ObservableObject {

    enum ViewState {
        case loaded(content: LoadedContent)
        case loadingError(Error)

        struct LoadedContent {
            let users: [User]
            let canLoadMore: Bool
        }

        var isError: Bool {
            if case .loadingError = self {
                return true
            }
            return false
        }
    }

    let pageItemsCount = 5

    struct ModelState {

        struct LoadedContent {
            let users: [User]
            let totalUsersCount: Int
        }

        let content: LoadedContent
        let error: Error?

        init(
            content: LoadedContent,
            error: Error? = nil
        ) {
            self.content = content
            self.error = error
        }

        func withError(_ error: Error) -> Self {
            .init(content: content, error: error)
        }
    }

    @Published var viewState: ViewState

    let networkManager: NetworkManager

    private(set) var state: ModelState

    var isloadingMore: Bool

    init(
        manager: NetworkManager
    ) {
        self.networkManager = manager
        self.state = .init(
            content: .init(users: [], totalUsersCount: 0),
            error: nil
        )
        self.viewState = Self.makeViewState(self.state)
        self.isloadingMore = false
        getUsers()
    }

    func getUsers() {
        guard !isloadingMore else { return }
        isloadingMore = true
        Task {
            do {
                let nextPage = state.content.users.count / pageItemsCount + 1
                // sleep for 1 second just for debugging purposes
                try await Task.sleep(nanoseconds: 1_000_000_000)
                let response = try await networkManager.getUsers(
                    page: nextPage,
                    count: pageItemsCount
                )
                await MainActor.run {
                    isloadingMore = false
                    let users = state.content.users + response.users
                    self.state = .init(
                        content: .init(
                            users: users,
                            totalUsersCount: response.total_users
                        )
                    )
                    self.viewState = Self.makeViewState(self.state)
                }
            } catch {
                await MainActor.run {
                    isloadingMore = false
                    state = state.withError(error)
                    self.viewState = .loadingError(error)
                }
            }
        }
    }

    static func makeViewState(_ state: ModelState) -> ViewState {
        if let error = state.error {
            return .loadingError(error)
        } else {
            return .loaded(content: .init(
                users: state.content.users,
                canLoadMore: state.content.users.count < state.content.totalUsersCount
            ))
        }
    }
}
