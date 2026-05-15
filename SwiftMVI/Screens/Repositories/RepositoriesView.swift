//
//  RepositoriesView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit
import SwiftUI

struct RepositoriesView: View {
    @State var state = RepositoriesState()
    @Injected(\.repositoriesInteractor) var interactor

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Repositories")
                .background(Color(.systemGroupedBackground))
                .navigationDestination(for: Repository.self) { repository in
                    RepositoryDetailView(repository: repository)
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
                Label("Couldn’t Load Repositories", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Retry") { interactor.load(state: state) }
                    .buttonStyle(.borderedProminent)
            }
        case .loaded(let repositories):
            loadedList(repositories)
        }
    }

    private func loadedList(_ repositories: [Repository]) -> some View {
        let filtered = state.searchText.isEmpty
            ? repositories
            : repositories.filter {
                $0.name.localizedCaseInsensitiveContains(state.searchText)
            }

        return List {
            Section {
                if filtered.isEmpty {
                    Text("No repositories found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filtered) { repository in
                        NavigationLink(value: repository) {
                            RepositoryRow(repository: repository)
                        }
                    }
                }
            } footer: {
                Text("\(repositories.count) repositories")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .searchable(text: $state.searchText, prompt: "Search repositories")
    }
}
