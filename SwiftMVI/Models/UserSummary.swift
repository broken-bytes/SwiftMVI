//
//  UserSummary.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Foundation

struct UserSummary: Sendable, Identifiable, Hashable {
    let id: Int
    let username: String
    let avatarUrl: URL?
}
