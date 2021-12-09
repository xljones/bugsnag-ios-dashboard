//
//  BugsnagDashboardApp.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI

var myToken: BSGToken = BSGToken.init()
//var myOrganizations: BSGOrganizations = []

func initOrganization() {
    print("Init: Token is '\(myToken.getToken())'")
    if myToken.isValid() {
        print("Init: Getting organizations")
    } else {
        print("Init: Can't get organizations, token is invalid")
    }
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
