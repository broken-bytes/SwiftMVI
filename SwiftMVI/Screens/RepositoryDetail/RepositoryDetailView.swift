//
//  RepositoryDetailView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import FactoryKit
import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository

    @State private var state = RepositoryDetailState()
    @Injected(\.repositoryDetailInteractor) private var interactor

    var body: some View {
        content
            .navigationTitle(repository.name)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private var content: some View {
        switch state.state {
        case .idle:
            Color(.systemGroupedBackground)
                .onAppear { interactor.load(repository: repository, state: state) }
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed:
            ContentUnavailableView {
                Label("Couldn’t Load Repository", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Retry") {
                    interactor.load(repository: repository, state: state)
                }
                .buttonStyle(.borderedProminent)
            }
        case .loaded(let detail):
            detailList(detail)
        }
    }

    private func detailList(_ detail: RepositoryDetail) -> some View {
        List {
            Section {
                HStack(spacing: 12) {
                    SettingsIcon(
                        systemName: repository.isPrivate ? "lock.fill" : "shippingbox.fill",
                        tint: repository.isPrivate ? .gray : .blue
                    )
                    VStack(alignment: .leading, spacing: 3) {
                        Text(repository.name)
                            .font(.headline)
                        Text(repository.fullName)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)

                if let description = repository.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Activity") {
                infoRow(icon: "star.fill", tint: .yellow,
                        title: "Stars", value: "\(repository.stars)")
                infoRow(icon: "tuningfork", tint: .purple,
                        title: "Forks", value: "\(repository.forks)")
                infoRow(icon: "eye.fill", tint: .teal,
                        title: "Watchers", value: "\(detail.watchers)")
                infoRow(icon: "exclamationmark.circle.fill", tint: .red,
                        title: "Open Issues", value: "\(detail.openIssues)")
            }

            Section("Details") {
                if let language = repository.language {
                    infoRow(icon: "chevron.left.forwardslash.chevron.right", tint: .indigo,
                            title: "Language", value: language)
                }
                infoRow(icon: "arrow.triangle.branch", tint: .blue,
                        title: "Default Branch", value: detail.defaultBranch)
                if let license = detail.license {
                    infoRow(icon: "scalemass.fill", tint: .gray,
                            title: "License", value: license)
                }
                infoRow(icon: "calendar", tint: .green,
                        title: "Created", value: detail.createdAt.formatted(date: .abbreviated, time: .omitted))
                infoRow(icon: "clock.fill", tint: .orange,
                        title: "Last Push", value: detail.pushedAt.formatted(date: .abbreviated, time: .omitted))
            }

            if !detail.topics.isEmpty {
                Section("Topics") {
                    Text(detail.topics.map { "#\($0)" }.joined(separator: "  "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                if let homepage = detail.homepage {
                    Link(destination: homepage) {
                        Label("Homepage", systemImage: "safari.fill")
                    }
                }
                if let url = repository.htmlUrl {
                    Link(destination: url) {
                        Label("Open on GitHub", systemImage: "arrow.up.forward.app.fill")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }

    private func infoRow(icon: String, tint: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            SettingsIcon(systemName: icon, tint: tint)
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
