//
//  RepositoryDetailDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Foundation

struct RepositoryDetailDTO: Decodable, Sendable {
    struct License: Decodable, Sendable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case license, homepage, topics
        case createdAt = "created_at"
        case pushedAt = "pushed_at"
        case openIssues = "open_issues_count"
        case watchers = "watchers_count"
        case defaultBranch = "default_branch"
    }

    let createdAt: Date
    let pushedAt: Date
    let openIssues: Int
    let watchers: Int
    let defaultBranch: String
    let license: License?
    let homepage: String?
    let topics: [String]
}
