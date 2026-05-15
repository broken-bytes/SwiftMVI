//
//  LoginState.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Observation

@Observable
class LoginState {
    enum State {
        case loading
        case loggedOut
        case deviceCode(DeviceCodeDTO)
        case failed
    }
    
    var state: State = .loggedOut
}
