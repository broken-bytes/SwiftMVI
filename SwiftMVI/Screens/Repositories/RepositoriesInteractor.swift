//
//  RepositoriesInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit

@MainActor
class RepositoriesInteractor {
    @Injected(\.repositoryService) var repositoryService: RepositoryService

    func load(state: RepositoriesState) {
        Task {
            do {
                state.state = .loading
                let repositories = try await repositoryService.fetchRepositories()
                state.state = .loaded(repositories)
            } catch {
                state.state = .failed
            }
        }
    }
}
