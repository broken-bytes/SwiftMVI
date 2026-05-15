//
//  ProfileInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit

@MainActor
class ProfileInteractor {
    @Injected(\.userService) var userService: UserService
    @Injected(\.authService) var authService: AuthService

    func load(state: ProfileState) {
        Task {
            do {
                state.state = .loading
                let user = try await userService.fetchUser()
                state.state = .loaded(user)
            } catch {
                state.state = .failed
            }
        }
    }

    func logout(appState: AppState) {
        authService.logout()
        appState.auth = .loggedOut
    }
}
