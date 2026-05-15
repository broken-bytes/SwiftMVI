//
//  UserSummaryDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

struct UserSummaryDTO: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
    }

    let id: Int
    let login: String
    let avatarUrl: String
}
