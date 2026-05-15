//
//  SwiftMVIApp.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import SwiftUI

@main
struct SwiftMVIApp: App {
    @State var appState: AppState = AppState()
    @Injected(\.appInteractor) var appInteractor
    
    var body: some Scene {
        WindowGroup {
            switch appState.auth {
            case .unknown:
                VStack {
                    ProgressView()
                }
                .onAppear {
                    Task {
                        await appInteractor.checkIfLoggedIn(state: appState)
                    }
                }
            case .loggedOut:
                LoginView()
                
            case .loggedIn:
                MainTabView()
            }
        }
            .environment(appState)
    }
}
