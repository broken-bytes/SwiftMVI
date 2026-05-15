//
//  TabRouter.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 16.05.26.
//

import Observation

enum AppTab: Hashable {
    case dashboard
    case repositories
    case profile
}

@Observable
class TabRouter {
    var selection: AppTab = .dashboard
}
