//
//  MainTabView.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import SwiftUI

struct MainTabView: View {
    @State private var tabRouter = TabRouter()

    var body: some View {
        TabView(selection: $tabRouter.selection) {
            Tab("Dashboard", systemImage: "square.grid.2x2.fill", value: AppTab.dashboard) {
                DashboardView()
            }

            Tab("Repositories", systemImage: "shippingbox.fill", value: AppTab.repositories) {
                RepositoriesView()
            }

            Tab("Profile", systemImage: "person.crop.circle.fill", value: AppTab.profile) {
                ProfileView()
            }
        }
        .environment(tabRouter)
    }
}
