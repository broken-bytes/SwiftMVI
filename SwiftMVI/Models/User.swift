//
//  User.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Foundation

struct User: Sendable {
    let id: Int
    let username: String
    let name: String?
    let bio: String?
    let avatarUrl: URL?
    let publicRepos: Int
    let followers: Int
    let following: Int
}
