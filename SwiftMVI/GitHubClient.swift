//
//  GitHubClient.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Foundation

class GitHubClient {
    enum GitHubError: Error {
        case aborted
        case codeExpired
        case unauthenticated
        case unknown
    }
    
    private struct PollErrorResponse: Decodable {
        let error: String
    }
    
    private static let clientId = "Iv23liuMS1sIBPE2uwkV"
    private static let githubAuthUrl = URL(
        string: "https://github.com/login/device/code?client_id=\(clientId)&scope=read:user+repo"
    )!
    private static let apiUrl = URL(string: "https://api.github.com")!
    
    private var accessToken: String?
    
    func fetchDeviceCode() async throws(GitHubError) -> DeviceCodeDTO {
        do {
            var request = URLRequest(url: GitHubClient.githubAuthUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let response = try await URLSession.shared.data(for: request)
                        
            let deviceCodeData = try JSONDecoder().decode(DeviceCodeDTO.self, from: response.0)
            
            return deviceCodeData
        } catch {
            throw GitHubError.unknown
        }
    }
    
    func pollForToken(code: DeviceCodeDTO) async throws(GitHubError) {
        var currentInterval = code.interval
        var secondsNow = 0
        do {
            while secondsNow < code.expiresIn {
                try await Task.sleep(for: .seconds(currentInterval))
                secondsNow += currentInterval
                
                var request = URLRequest(
                    url: URL(string: "https://github.com/login/oauth/access_token")!
                )
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue(
                    "application/x-www-form-urlencoded",
                    forHTTPHeaderField: "Content-Type"
                )
                request.httpBody = "client_id=\(GitHubClient.clientId)&device_code=\(code.deviceCode)&grant_type=urn:ietf:params:oauth:grant-type:device_code"
                        .data(using: .utf8)
                    
                let (data, _) = try await URLSession.shared.data(for: request)

                if let success = try? JSONDecoder().decode(TokenResponseDTO.self, from: data) {
                    self.accessToken = success.accessToken
                    
                    return
                }
                
                let errorResponse = try JSONDecoder().decode(PollErrorResponse.self, from: data)
                switch errorResponse.error {
                case "authorization_pending":
                    continue
                case "slow_down":
                    currentInterval += 5
                case "expired_token":
                    throw GitHubError.codeExpired
                case "access_denied":
                    throw GitHubError.aborted
                default:
                    throw GitHubError.unknown
                }
            }
            throw GitHubError.codeExpired
        } catch let error as GitHubError {
            throw error
        } catch {
            throw GitHubError.unknown
        }
    }
    
    func fetchRepositories() async throws(GitHubError) -> [RepositoryDTO] {
        guard
            let accessToken
        else {
            throw GitHubError.unauthenticated
        }

        var components = URLComponents(
            url: GitHubClient.apiUrl.appendingPathComponent("user/repos"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "sort", value: "created"),
            URLQueryItem(name: "direction", value: "desc"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "affiliation", value: "owner")
        ]

        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode([RepositoryDTO].self, from: data)
        } catch {
            throw GitHubError.unauthenticated
        }
    }

    func fetchRepositoryDetail(fullName: String) async throws(GitHubError) -> RepositoryDetailDTO {
        try await authorizedGet(
            GitHubClient.apiUrl.appendingPathComponent("repos/\(fullName)")
        )
    }

    func fetchFollowers(username: String) async throws(GitHubError) -> [UserSummaryDTO] {
        try await authorizedGet(
            GitHubClient.apiUrl
                .appendingPathComponent("users")
                .appendingPathComponent(username)
                .appendingPathComponent("followers")
        )
    }

    func fetchFollowing(username: String) async throws(GitHubError) -> [UserSummaryDTO] {
        try await authorizedGet(
            GitHubClient.apiUrl
                .appendingPathComponent("users")
                .appendingPathComponent(username)
                .appendingPathComponent("following")
        )
    }

    private func authorizedGet<T: Decodable>(_ url: URL) async throws(GitHubError) -> T {
        guard
            let accessToken
        else {
            throw GitHubError.unauthenticated
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.setValue("SwiftMVI", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                throw http.statusCode == 401
                    ? GitHubError.unauthenticated
                    : GitHubError.unknown
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode(T.self, from: data)
        } catch let error as GitHubError {
            throw error
        } catch {
            throw GitHubError.unknown
        }
    }

    func logout() {
        accessToken = nil
    }

    func fetchUserInfo() async throws(GitHubError) -> UserDTO {
        guard
            let accessToken
        else {
            throw GitHubError.unauthenticated
        }
        
        let userUrl = GitHubClient.apiUrl.appendingPathComponent("user")
        
        var request = URLRequest(url: userUrl)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let userData = try JSONDecoder().decode(UserDTO.self, from: data)
            
            return userData
        } catch {
            throw GitHubError.unauthenticated
        }
    }
}
