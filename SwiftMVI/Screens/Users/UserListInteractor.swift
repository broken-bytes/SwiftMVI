//
//  UserListInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit

@MainActor
class UserListInteractor {
    @Injected(\.userService) var userService: UserService

    func load(mode: UserListMode, username: String, state: UserListState) {
        Task {
            do {
                state.state = .loading

                let users: [UserSummary]
                switch mode {
                case .followers:
                    users = try await userService.fetchFollowers(username: username)
                case .following:
                    users = try await userService.fetchFollowing(username: username)
                }

                state.state = .loaded(users)
            } catch {
                state.state = .failed
            }
        }
    }
}
