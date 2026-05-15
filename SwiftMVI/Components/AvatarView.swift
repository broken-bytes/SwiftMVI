//
//  AvatarView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import SwiftUI

struct AvatarView: View {
    let url: URL?
    var size: CGFloat = 40

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(.circle)
        .overlay {
            Circle().strokeBorder(.separator, lineWidth: 0.5)
        }
    }
}
