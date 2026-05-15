//
//  UserListState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Observation

@Observable
class UserListState {
    enum State {
        case idle
        case loading
        case loaded([UserSummary])
        case failed
    }

    var state: State = .idle
}
