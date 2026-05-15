//
//  Repository.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Foundation

struct Repository: Sendable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stars: Int
    let forks: Int
    let isPrivate: Bool
    let updatedAt: Date
    let pushedAt: Date
    let htmlUrl: URL?
}
