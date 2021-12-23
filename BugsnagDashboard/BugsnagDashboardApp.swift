//
//  BugsnagDashboardApp.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI
import Bugsnag
import BugsnagNetworkRequestPlugin


@main
struct BugsnagDashboardApp: App {
    init() {
        let bugsnagConfiguration = BugsnagConfiguration.loadConfig()
        bugsnagConfiguration.add(BugsnagNetworkRequestPlugin())
        Bugsnag.start(with: bugsnagConfiguration)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
