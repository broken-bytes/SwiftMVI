//
//  RepositoriesState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Observation

@Observable
class RepositoriesState {
    enum State {
        case idle
        case loading
        case loaded([Repository])
        case failed
    }

    var state: State = .idle
    var searchText: String = ""
}
