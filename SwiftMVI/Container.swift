//
//  Container.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit

@MainActor
extension Container {
    var appInteractor: Factory<AppInteractor> {
        self { AppInteractor() }
    }
    
    var loginInteractor: Factory<LoginInteractor> {
        self { LoginInteractor() }
    }
    
    var dashboardInteractor: Factory<DashboardInteractor> {
        self { DashboardInteractor() }
    }

    var repositoriesInteractor: Factory<RepositoriesInteractor> {
        self { RepositoriesInteractor() }
    }

    var profileInteractor: Factory<ProfileInteractor> {
        self { ProfileInteractor() }
    }

    var repositoryDetailInteractor: Factory<RepositoryDetailInteractor> {
        self { RepositoryDetailInteractor() }
    }

    var userListInteractor: Factory<UserListInteractor> {
        self { UserListInteractor() }
    }

    var authService: Factory<AuthService> {
        self { AuthService() }
    }

    var userService: Factory<UserService> {
        self { UserService() }
    }

    var repositoryService: Factory<RepositoryService> {
        self { RepositoryService() }
    }
    
    var gitHubClient: Factory<GitHubClient> {
        self { GitHubClient() }
            .singleton
    }
}
