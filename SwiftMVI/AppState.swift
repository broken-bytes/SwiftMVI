//
//  AppState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Observation

@Observable
class AppState {
    enum AuthStatus {
        case unknown
        case loggedOut
        case loggedIn(User)
    }

    var auth: AuthStatus = .unknown
}
