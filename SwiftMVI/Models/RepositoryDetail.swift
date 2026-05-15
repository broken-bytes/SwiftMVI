//
//  RepositoryDetail.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Foundation

struct RepositoryDetail: Sendable {
    let repository: Repository
    let createdAt: Date
    let pushedAt: Date
    let openIssues: Int
    let watchers: Int
    let defaultBranch: String
    let license: String?
    let homepage: URL?
    let topics: [String]
}
