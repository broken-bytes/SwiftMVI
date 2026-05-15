//
//  UserListView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit
import SwiftUI

struct UserListView: View {
    let mode: UserListMode
    let username: String

    @State private var state = UserListState()
    @Injected(\.userListInteractor) private var interactor

    var body: some View {
        content
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private var content: some View {
        switch state.state {
        case .idle:
            Color(.systemGroupedBackground)
                .onAppear { interactor.load(mode: mode, username: username, state: state) }
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed:
            ContentUnavailableView {
                Label("Couldn’t Load \(mode.title)", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Retry") { interactor.load(mode: mode, username: username, state: state) }
                    .buttonStyle(.borderedProminent)
            }
        case .loaded(let users):
            loadedList(users)
        }
    }

    private func loadedList(_ users: [UserSummary]) -> some View {
        List {
            Section {
                if users.isEmpty {
                    Text(mode.emptyMessage)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(users) { user in
                        HStack(spacing: 12) {
                            AvatarView(url: user.avatarUrl, size: 36)
                            Text(user.username)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                }
            } footer: {
                if !users.isEmpty {
                    Text("\(users.count) \(mode.title.lowercased())")
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }
}
