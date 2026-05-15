//
//  DashboardInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit

@MainActor
class DashboardInteractor {
    @Injected(\.userService) var userService: UserService
    @Injected(\.repositoryService) var repositoryService: RepositoryService

    func load(state: DashboardState) {
        Task {
            do {
                state.state = .loading

                let user = try await userService.fetchUser()
                let repositories = try await repositoryService.fetchRepositories()
                let recent = repositories
                    .sorted { $0.pushedAt > $1.pushedAt }
                    .prefix(3)
                    .map { $0 }

                state.state = .loaded(
                    DashboardState.Content(user: user, recentRepositories: recent)
                )
            } catch {
                state.state = .failed
            }
        }
    }
}
