//
//  ProfileView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit
import SwiftUI

struct ProfileView: View {
    @State var state = ProfileState()
    @Injected(\.profileInteractor) var interactor
    @Environment(AppState.self) var appState: AppState
    @Environment(TabRouter.self) var tabRouter: TabRouter

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Profile")
                .background(Color(.systemGroupedBackground))
                .navigationDestination(for: UserListRoute.self) { route in
                    UserListView(mode: route.mode, username: route.username)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state.state {
        case .idle:
            Color(.systemGroupedBackground)
                .onAppear { interactor.load(state: state) }
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed:
            ContentUnavailableView {
                Label("Couldn’t Load Profile", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Retry") { interactor.load(state: state) }
                    .buttonStyle(.borderedProminent)
            }
        case .loaded(let user):
            profileForm(user)
        }
    }

    private func profileForm(_ user: User) -> some View {
        List {
            Section {
                HStack(spacing: 16) {
                    AvatarView(url: user.avatarUrl, size: 64)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(user.name ?? user.username)
                            .font(.title3.weight(.semibold))
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)

                if let bio = user.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Statistics") {
                Button {
                    tabRouter.selection = .repositories
                } label: {
                    statRow(icon: "shippingbox.fill", tint: .blue,
                            title: "Repositories", value: user.publicRepos)
                }
                .buttonStyle(.plain)

                NavigationLink(value: UserListRoute(mode: .followers, username: user.username)) {
                    statRow(icon: "person.2.fill", tint: .green,
                            title: "Followers", value: user.followers)
                }

                NavigationLink(value: UserListRoute(mode: .following, username: user.username)) {
                    statRow(icon: "person.fill.checkmark", tint: .orange,
                            title: "Following", value: user.following)
                }
            }

            Section {
                Button(role: .destructive) {
                    interactor.logout(appState: appState)
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                        Spacer()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }

    private func statRow(icon: String, tint: Color, title: String, value: Int) -> some View {
        HStack(spacing: 12) {
            SettingsIcon(systemName: icon, tint: tint)
            Text(title)
            Spacer()
            Text("\(value)")
                .foregroundStyle(.secondary)
        }
    }
}
