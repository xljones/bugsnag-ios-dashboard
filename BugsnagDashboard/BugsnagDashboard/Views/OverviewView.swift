//
//  OverviewView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct OverviewView: View {
    @Binding var activeProject: ActiveProject?
    @State var projectOverview: BSGProjectOverview?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if let project = activeProject {
                    Text(project.details.name)
                    Text(project.details.id)
                    Text(project.details.slug)
                } else {
                    Text("No active project set")
                }
            }
            .refreshable {
                if let project = activeProject {
                    getProjectOverview(token: myToken, project: project.details, completionHandler: {
                        switch $0 {
                        case let .success(rtnProjectOverview):
                            projectOverview = rtnProjectOverview
                            print("getProjectOverview Success")
                        case let .failure(error):
                            print("getProjectOverview Failed: \(error)")
                        }
                    })
                }
            }
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var testProject = BSGProject.init(id: "613a095c6e7316000ef78276", organizationID: "6113b207304caa000e308c2a", slug: "test-project", name: "My Test Project", apiKey: "97ef27a04c69ae72307ba2a3b7168b5b", type: "iOS", isFullView: true, releaseStages: ["production", "development"], language: "language", createdAt: "2021-12-01 12:00:00", updatedAt: "2021-12-01 12:00:00", errorsURL: "https://errorsURL.com", eventsURL: "https://eventsURL.com", url: "https://URL.com", htmlURL: "https://htmlURL.com", openErrorCount: 190, forReviewErrorCount: 25, collaboratorsCount: 4, globalGrouping: [], locationGrouping: [], discardedAppVersions: [], discardedErrors: [], customEventFieldsUsed: 2, resolveOnDeploy: false, urlWhitelist: [], ignoreOldBrowsers: false)
    @State static var testActiveProject: ActiveProject? = ActiveProject.init(index:1, details: testProject)
    static var previews: some View {
        OverviewView(activeProject: $testActiveProject)
    }
}
