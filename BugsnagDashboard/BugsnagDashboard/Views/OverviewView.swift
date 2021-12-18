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
    
    func refreshOverview() {
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
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Overview")
                    .font(.title)
                if let project = activeProject {
                    Text(project.details.name)
                        .font(.footnote)
                }
            }.padding(.trailing, 20).padding(.leading, 20).padding(.bottom, 10)
            Divider()
            VStack(alignment: .leading) {
                List {
                    if let overview = projectOverview {
                        Section(header: Text("Project Information")) {
                            VStack(alignment: .leading) {
                                Text("id").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                Text(overview.projectID)
                            }
                        }
                        Section(header: Text("Errors For Review")) {
                            VStack(alignment: .leading) {
                                Text("current").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                Text(String(overview.forReview.current))
                            }
                            VStack(alignment: .leading) {
                                Text("one week ago").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                Text(String(overview.forReview.oneWeekAgo))
                            }
                        }
                        Section(header: Text("Latest Release")) {
                            if let latestRelease = overview.latestRelease {
                                VStack(alignment: .leading) {
                                    Text("release group id").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                    Text(latestRelease.releaseGroupId)
                                }
                                VStack(alignment: .leading) {
                                    Text("first release time").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                    Text(latestRelease.firstReleaseTime)
                                }
                                VStack(alignment: .leading) {
                                    Text("app version").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                                    Text(latestRelease.appVersion)
                                }
                            } else {
                                Text("No latest release for this project.")
                                    .foregroundColor(BSGExtendedColors.batman40)
                            }
                        }
                    } else {
                        Text("No overview information available")
                            .foregroundColor(BSGExtendedColors.batman40)
                    }
                }
                .refreshable {
                    refreshOverview()
                }
                .listStyle(GroupedListStyle())
                .onAppear {
                    refreshOverview()
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
