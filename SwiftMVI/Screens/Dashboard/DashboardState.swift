//
//  DashboardState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Observation

@Observable
class DashboardState {
    struct Content {
        let user: User
        let recentRepositories: [Repository]
    }

    enum State {
        case idle
        case loading
        case loaded(Content)
        case failed
    }

    var state: State = .idle
}
