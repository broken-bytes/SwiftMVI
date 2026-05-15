//
//  RepositoryDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Foundation

struct RepositoryDTO: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case isPrivate = "private"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case htmlUrl = "html_url"
    }

    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let isPrivate: Bool
    let updatedAt: Date
    let pushedAt: Date
    let htmlUrl: String
}
