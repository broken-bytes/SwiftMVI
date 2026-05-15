//
//  RepositoryDetailInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit

@MainActor
class RepositoryDetailInteractor {
    @Injected(\.repositoryService) var repositoryService: RepositoryService

    func load(repository: Repository, state: RepositoryDetailState) {
        Task {
            do {
                state.state = .loading
                let detail = try await repositoryService.fetchDetail(for: repository)
                state.state = .loaded(detail)
            } catch {
                state.state = .failed
            }
        }
    }
}
