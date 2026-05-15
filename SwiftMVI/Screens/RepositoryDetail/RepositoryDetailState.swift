//
//  RepositoryDetailState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Observation

@Observable
class RepositoryDetailState {
    enum State {
        case idle
        case loading
        case loaded(RepositoryDetail)
        case failed
    }

    var state: State = .idle
}
