//
//  UserDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

struct UserDTO: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case login, id, name, bio, followers, following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
    
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String?
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
}
