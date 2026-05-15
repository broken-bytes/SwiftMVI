//
//  LoginView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import SwiftUI

struct LoginView: View {
    @State var loginState = LoginState()
    @Injected(\.loginInteractor) var interactor
    @Environment(AppState.self) var appState: AppState
    
    var body: some View {
        switch loginState.state {
        case .loading:
            loadingView
        case .loggedOut:
            loggedOutView
        case .deviceCode(let deviceCode):
            deviceCodeFetchedView(deviceCode: deviceCode)
        case .failed:
            errorView
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
        }
    }
    
    private var loggedOutView: some View {
        VStack {
            Text("Logged Out")
            
            Button(action: {
                interactor.fetchDeviceCode(state: loginState, appState: appState)
            }, label: {
                Text("Login")
            })
        }
    }
    
    private var errorView: some View {
        Text("Error")
    }
    
    private func deviceCodeFetchedView(deviceCode: DeviceCodeDTO) -> some View {
        VStack(spacing: 20) {
            Text("Enter this code on GitHub")
                .font(.headline)

            Text(deviceCode.userCode)
                .font(.system(.largeTitle, design: .monospaced))
                .fontWeight(.bold)
                .textSelection(.enabled)
                .padding()
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))

            Button("Open GitHub") {
                let urlWithCode = URL(string: "\(deviceCode.verificationUri.absoluteString)?user_code=\(deviceCode.userCode)")!
                UIApplication.shared.open(urlWithCode)
            }
            .buttonStyle(.borderedProminent)

            ProgressView()
            Text("Waiting for authorization…")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .onAppear {
            UIPasteboard.general.string = deviceCode.userCode
        }
    }
}
