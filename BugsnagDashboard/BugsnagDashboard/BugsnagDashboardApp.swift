//
//  BugsnagDashboardApp.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI

var myToken: BSGToken = BSGToken.init(token: "")
var myOrg: BSGOrganization = BSGOrganization.init(id: "", name: "", slug: "")

func initOrganization() {
    myOrg = getOrganizations(token: myToken)
}

@main
struct BugsnagDashboardApp: App {
    init() {
        initOrganization()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
