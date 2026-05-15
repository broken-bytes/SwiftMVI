//
//  RepositoryService.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import Foundation

class RepositoryService {
    enum RepositoryError: Error {
        case unauthenticated
        case unknown
    }

    @Injected(\.gitHubClient) var gitHubClient

    func fetchRepositories() async throws(RepositoryError) -> [Repository] {
        do {
            let repositories = try await gitHubClient.fetchRepositories()

            return repositories.map { dto in
                Repository(
                    id: dto.id,
                    name: dto.name,
                    fullName: dto.fullName,
                    description: dto.description,
                    language: dto.language,
                    stars: dto.stargazersCount,
                    forks: dto.forksCount,
                    isPrivate: dto.isPrivate,
                    updatedAt: dto.updatedAt,
                    pushedAt: dto.pushedAt,
                    htmlUrl: URL(string: dto.htmlUrl)
                )
            }
        } catch {
            switch error {
            case .unauthenticated:
                throw RepositoryError.unauthenticated
            default:
                throw RepositoryError.unknown
            }
        }
    }

    func fetchDetail(for repository: Repository) async throws(RepositoryError) -> RepositoryDetail {
        do {
            let dto = try await gitHubClient.fetchRepositoryDetail(fullName: repository.fullName)

            return RepositoryDetail(
                repository: repository,
                createdAt: dto.createdAt,
                pushedAt: dto.pushedAt,
                openIssues: dto.openIssues,
                watchers: dto.watchers,
                defaultBranch: dto.defaultBranch,
                license: dto.license?.name,
                homepage: dto.homepage.flatMap { $0.isEmpty ? nil : URL(string: $0) },
                topics: dto.topics
            )
        } catch {
            switch error {
            case .unauthenticated:
                throw RepositoryError.unauthenticated
            default:
                throw RepositoryError.unknown
            }
        }
    }
}
