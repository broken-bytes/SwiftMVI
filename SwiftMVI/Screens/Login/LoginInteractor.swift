//
//  LoginInteractor.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import Foundation

@MainActor
class LoginInteractor {
    @Injected(\.authService) var authService
    @Injected(\.userService) var userService
    
    func fetchDeviceCode(state: LoginState, appState: AppState) {
        state.state = .loading
        
        Task {
            do {
                let deviceCode = try await authService.fetchDeviceCode()
                state.state = .deviceCode(deviceCode)
            
                try await authService.pollForToken(code: deviceCode)
                
                let user = try await userService.fetchUser()
                
                appState.auth = .loggedIn(user)
            } catch {
                state.state = .failed
            }
        }
    }

    private struct TokenResponse: Decodable {
        let accessToken: String
        enum CodingKeys: String, CodingKey { case accessToken = "access_token" }
    }

    private struct PollErrorResponse: Decodable {
        let error: String
    }

    enum AuthError: LocalizedError {
        case cancelled
        case expired
        case unknown(String)

        var errorDescription: String? {
            switch self {
            case .cancelled: 
                return "Authorization was cancelled"
            case .expired: 
                return "The code expired. Please try again."
            case .unknown(let msg): 
                return "Authentication failed: \(msg)"
            }
        }
    }
}
