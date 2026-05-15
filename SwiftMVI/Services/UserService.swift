//
//  UserService.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import Foundation

class UserService {
    enum UserError: Error {
        case unauthenticated
        case unknown
    }
    
    @Injected(\.gitHubClient) var gitHubClient
    
    func fetchUser() async throws(UserError) -> User {
        do {
            let user = try await gitHubClient.fetchUserInfo()

            return User(
                id: user.id,
                username: user.login,
                name: user.name,
                bio: user.bio,
                avatarUrl: URL(string: user.avatarUrl),
                publicRepos: user.publicRepos,
                followers: user.followers,
                following: user.following
            )
        } catch {
            switch error {
            case .unauthenticated:
                throw UserError.unauthenticated
            default:
                throw UserError.unknown
            }
        }
    }

    func fetchFollowers(username: String) async throws(UserError) -> [UserSummary] {
        do {
            return try await gitHubClient.fetchFollowers(username: username).map(Self.map)
        } catch {
            switch error {
            case .unauthenticated:
                throw UserError.unauthenticated
            default:
                throw UserError.unknown
            }
        }
    }

    func fetchFollowing(username: String) async throws(UserError) -> [UserSummary] {
        do {
            return try await gitHubClient.fetchFollowing(username: username).map(Self.map)
        } catch {
            switch error {
            case .unauthenticated:
                throw UserError.unauthenticated
            default:
                throw UserError.unknown
            }
        }
    }
}

fileprivate extension UserService {
    static func map(_ dto: UserSummaryDTO) -> UserSummary {
        UserSummary(
            id: dto.id,
            username: dto.login,
            avatarUrl: URL(string: dto.avatarUrl)
        )
    }
}
