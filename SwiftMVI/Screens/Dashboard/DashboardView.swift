//
//  DashboardView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import FactoryKit
import SwiftUI

struct DashboardView: View {
    @State var state = DashboardState()
    @Injected(\.dashboardInteractor) var interactor

    var body: some View {
        Group {
            switch state.state {
            case .idle:
                idleView
            case .loading:
                loadingView
            case .failed:
                errorView
            case .loaded(let content):
                loadedView(content: content)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private var idleView: some View {
        Color(.systemGroupedBackground)
            .onAppear {
                interactor.load(state: state)
            }
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var errorView: some View {
        ContentUnavailableView {
            Label("Couldn’t Load Dashboard", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text("Check your connection and try again.")
        } actions: {
            Button("Retry") {
                interactor.load(state: state)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func loadedView(content: DashboardState.Content) -> some View {
        NavigationStack {
            VStack(spacing: 0) {
                header(for: content.user)

                List {
                    Section {
                        if content.recentRepositories.isEmpty {
                            Text("No repositories yet")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(content.recentRepositories) { repository in
                                NavigationLink(value: repository) {
                                    RepositoryRow(repository: repository)
                                }
                            }
                        }
                    } header: {
                        Text("Recent Repositories")
                    } footer: {
                        Text("Your three most recently active repositories.")
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Repository.self) { repository in
                RepositoryDetailView(repository: repository)
            }
        }
    }

    private func header(for user: User) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("MVI Demo")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text("@\(user.username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            AvatarView(url: user.avatarUrl, size: 48)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
