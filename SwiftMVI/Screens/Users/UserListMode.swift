//
//  UserListMode.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

struct UserListRoute: Hashable {
    let mode: UserListMode
    let username: String
}

enum UserListMode: Hashable {
    case followers
    case following

    var title: String {
        switch self {
        case .followers: return "Followers"
        case .following: return "Following"
        }
    }

    var emptyMessage: String {
        switch self {
        case .followers: return "No followers yet"
        case .following: return "Not following anyone yet"
        }
    }
}
