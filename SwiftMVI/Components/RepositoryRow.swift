//
//  RepositoryRow.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import SwiftUI

struct RepositoryRow: View {
    let repository: Repository

    var body: some View {
        HStack(spacing: 12) {
            SettingsIcon(
                systemName: repository.isPrivate ? "lock.fill" : "shippingbox.fill",
                tint: repository.isPrivate ? .gray : .blue
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(repository.name)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if let description = repository.description, !description.isEmpty {
                    Text(description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 12) {
                    if let language = repository.language {
                        Label(language, systemImage: "circle.fill")
                            .labelStyle(.titleAndIcon)
                    }

                    Label("\(repository.stars)", systemImage: "star.fill")

                    Label("\(repository.forks)", systemImage: "tuningfork")
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
