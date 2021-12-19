//
//  InboxView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct InboxView: View {
    @Binding var activeProject: ActiveProject?
    @State var latestErrors: [BSGError]?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    func refreshLatestErrors() {
        if let project = activeProject {
            getErrors(token: myToken, project: project.details) {
                switch $0 {
                case let .success(rtnErrors):
                    latestErrors = rtnErrors
                    print(latestErrors as Any)
                    print("getErrors Success (on appear)")
                case let .failure(error):
                    print("getProjects Failed (on appear): \(error)")
                }
            }
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TabTitle(activeProject: $activeProject, title: "Inbox")
            VStack(alignment: .leading) {
                List {
                    Section(header: Text("Latest errors")) {
                        if let errs = latestErrors {
                            if (errs.count == 0) {
                                Text("No errors on this project")
                                    .foregroundColor(BSGExtendedColors.batman40)
                            } else {
                                ForEach(errs, id: \.id) { err in
                                    VStack(alignment: .leading) {
                                        Text("class").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                        Text(err.errorClass)
                                        Text("message").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                        Text(err.message)
                                        Text("context").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                        Text(err.context)
                                    }
                                }
                            }
                        } else {
                            Text("No error information available.")
                                .foregroundColor(BSGExtendedColors.batman40)
                        }
                    }
                }
                .refreshable {
                    refreshLatestErrors()
                }
                .listStyle(GroupedListStyle())
            }
            .onAppear {
                refreshLatestErrors()
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var testProject = BSGProject.init(id: "613a095c6e7316000ef78276", organizationID: "6113b207304caa000e308c2a", slug: "test-project", name: "My Test Project", apiKey: "97ef27a04c69ae72307ba2a3b7168b5b", type: "iOS", isFullView: true, releaseStages: ["production", "development"], language: "language", createdAt: "2021-12-01 12:00:00", updatedAt: "2021-12-01 12:00:00", errorsURL: "https://errorsURL.com", eventsURL: "https://eventsURL.com", url: "https://URL.com", htmlURL: "https://htmlURL.com", openErrorCount: 190, forReviewErrorCount: 25, collaboratorsCount: 4, globalGrouping: [], locationGrouping: [], discardedAppVersions: [], discardedErrors: [], customEventFieldsUsed: 2, resolveOnDeploy: false, urlWhitelist: [], ignoreOldBrowsers: false)
    @State static var testActiveProject: ActiveProject? = ActiveProject.init(index: 1, details: testProject)
    static var previews: some View {
        InboxView(activeProject: $testActiveProject)
    }
}
