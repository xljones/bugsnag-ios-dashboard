//
//  TimelineView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct TimelineView: View {
    @Binding var activeProject: ActiveProject?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Timeline")
                    .font(.title)
                if let project = activeProject {
                    Text(project.details.name)
                        .font(.footnote)
                }
            }.padding(20)
            Divider()
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var testProject = BSGProject.init(id: "613a095c6e7316000ef78276", organizationID: "6113b207304caa000e308c2a", slug: "test-project", name: "My Test Project", apiKey: "97ef27a04c69ae72307ba2a3b7168b5b", type: "iOS", isFullView: true, releaseStages: ["production", "development"], language: "language", createdAt: "2021-12-01 12:00:00", updatedAt: "2021-12-01 12:00:00", errorsURL: "https://errorsURL.com", eventsURL: "https://eventsURL.com", url: "https://URL.com", htmlURL: "https://htmlURL.com", openErrorCount: 190, forReviewErrorCount: 25, collaboratorsCount: 4, globalGrouping: [], locationGrouping: [], discardedAppVersions: [], discardedErrors: [], customEventFieldsUsed: 2, resolveOnDeploy: false, urlWhitelist: [], ignoreOldBrowsers: false)
    @State static var testActiveProject: ActiveProject? = ActiveProject.init(index: 1, details: testProject)
    static var previews: some View {
        TimelineView(activeProject: $testActiveProject)
    }
}
