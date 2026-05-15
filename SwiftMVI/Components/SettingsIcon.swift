//
//  SettingsIcon.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import SwiftUI

/// The signature iOS Settings row glyph: an SF Symbol on a colored, rounded square.
struct SettingsIcon: View {
    let systemName: String
    let tint: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(tint.gradient)
            .frame(width: 29, height: 29)
            .overlay {
                Image(systemName: systemName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
    }
}
