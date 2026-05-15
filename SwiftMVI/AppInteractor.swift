//
//  AppInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

class AppInteractor {
    func checkIfLoggedIn(state: AppState) async {
        state.auth = .loggedOut
    }
}
