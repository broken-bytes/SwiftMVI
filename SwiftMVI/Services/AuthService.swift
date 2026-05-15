//
//  AuthService.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import Foundation

class AuthService {
    enum AuthError: Error {
        case aborted
        case codeExpired
        case unknown
    }
    
    @Injected(\.gitHubClient) var gitHubClient: GitHubClient

    func loadUser() async -> User? {
        return nil
    }

    func logout() {
        gitHubClient.logout()
    }
    
    func fetchDeviceCode() async throws (AuthError) -> DeviceCodeDTO {
        do {
            let data = try await gitHubClient.fetchDeviceCode()
            
            return data
        } catch {
            throw AuthError.unknown
        }
    }
    
    func pollForToken(code: DeviceCodeDTO) async throws(AuthError) {
        do {
            try await gitHubClient.pollForToken(code: code)
        } catch {
            switch error {
            case .aborted:
                throw AuthError.aborted
            case .codeExpired:
                throw AuthError.codeExpired
            default:
                throw AuthError.unknown
            }
        }
    }
}
