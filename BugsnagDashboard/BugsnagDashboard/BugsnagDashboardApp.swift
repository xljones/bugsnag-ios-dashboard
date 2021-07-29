//
//  BugsnagDashboardApp.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI

@main
struct BugsnagDashboardApp: App {
    
    let bugsnagDAAToken: String =  "MY_TOKEN"
    var organization = BSGOrganization.init(id: "abcdef1234556788", name: "My Org")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
