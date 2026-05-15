//
//  ProfileState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Observation

@Observable
class ProfileState {
    enum State {
        case idle
        case loading
        case loaded(User)
        case failed
    }

    var state: State = .idle
}
