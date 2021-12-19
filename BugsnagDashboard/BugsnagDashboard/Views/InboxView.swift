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
                                    ErrorTableRow(errorToRender: err)
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

struct ErrorTableRow: View {
    let err: BSGError
    
    init(errorToRender: BSGError) {
        err = errorToRender
        print(err.releaseStages)
    }
    
    func friendlyFirstLastSeenTimestamp(firstSeen: String, lastSeen: String) -> String {
        let firstSeenRelative = getRelativeTimestamp(iso8601Timestamp: firstSeen)
        let lastSeenRelative = getRelativeTimestamp(iso8601Timestamp: lastSeen)
        
        if firstSeenRelative == lastSeenRelative {
            return "about " + lastSeenRelative
        } else {
            return "about " + lastSeenRelative + " – " + firstSeenRelative
        }
    }
    
    func getRelativeTimestamp(iso8601Timestamp: String) -> String {
        // https://stackoverflow.com/a/42101630/6277366 setup formatter for Rails formatted output
        let railsIso8601Formatter = ISO8601DateFormatter()
        railsIso8601Formatter.formatOptions = [.withFullDate,
                                               .withTime,
                                               .withDashSeparatorInDate,
                                               .withColonSeparatorInTime]
        let timestamp = railsIso8601Formatter.date(from: iso8601Timestamp)
        if timestamp != nil {
            let relativeTimestamp = RelativeDateTimeFormatter().localizedString(for: timestamp!, relativeTo: Date())
            return relativeTimestamp
        } else {
            return iso8601Timestamp
        }
    }
    
    func calcSeverityColor(severity: String) -> Color {
        switch severity {
        case "error":
            return Color.red
        case "warning":
            return Color.orange
        case "info":
            return Color.blue
        default:
            return Color.red
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(alignment: .center) {
                Text(err.severity.uppercased())
                    .bold()
                    .font(.system(size:10))
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .foregroundColor(Color.white)
                    .background(calcSeverityColor(severity: err.severity))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(calcSeverityColor(severity: err.severity), lineWidth: 1)
                    )
                let additionalReleaseStages: String = err.releaseStages.count > 1 ? " + \(err.releaseStages.count - 1)" : ""
                Text("\(err.releaseStages[0])\(additionalReleaseStages)")
                        .font(.system(size:10))
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
            }.padding(.bottom, 3)
            HStack(alignment: .center) {
                Text(err.errorClass)
                    .bold()
                Text(err.context)
                    .frame(height:12)
                    .truncationMode(.tail)
            }
            Text(err.message)
                .font(.system(size:11))
                .foregroundColor(BSGExtendedColors.batman70)
                .frame( height:11)
                .truncationMode(.tail)
            Text(friendlyFirstLastSeenTimestamp(firstSeen: err.firstSeen, lastSeen: err.lastSeen))
                .font(.system(size:11))
                .foregroundColor(BSGExtendedColors.batman40)
                .frame( height:11)
                .padding(.top, 3)
        }
        .font(.system(size:12))
    }
}

struct InboxView_Previews: PreviewProvider {
    static var testProject = BSGProject.init(id: "613a095c6e7316000ef78276", organizationID: "6113b207304caa000e308c2a", slug: "test-project", name: "My Test Project", apiKey: "97ef27a04c69ae72307ba2a3b7168b5b", type: "iOS", isFullView: true, releaseStages: ["production", "development", "staging"], language: "language", createdAt: "2021-12-01 12:00:00", updatedAt: "2021-12-01 12:00:00", errorsURL: "https://errorsURL.com", eventsURL: "https://eventsURL.com", url: "https://URL.com", htmlURL: "https://htmlURL.com", openErrorCount: 190, forReviewErrorCount: 25, collaboratorsCount: 4, globalGrouping: [], locationGrouping: [], discardedAppVersions: [], discardedErrors: [], customEventFieldsUsed: 2, resolveOnDeploy: false, urlWhitelist: [], ignoreOldBrowsers: false)
    @State static var testActiveProject: ActiveProject? = ActiveProject.init(index: 1, details: testProject)
    static var previews: some View {
        InboxView(activeProject: $testActiveProject)
    }
}

struct ErrorTableRow_Previews: PreviewProvider {
    static let sampleError = "{\"id\": \"618964a1308b00000a0c130b\",\"project_id\": \"5e4a9527ef8b1a000e53bed5\",\"error_class\": \"Fatal error\",\"message\": \"Restarting app to switch endpoints\",\"context\": \"closure #1 in variable initialization expression of ViewController.sections\",\"severity\": \"error\",\"original_severity\": \"error\",\"overridden_severity\": null,\"events\": 1,\"events_url\": \"https://api.bugsnag.com/projects/5e4a9527ef8b1a000e53bed5/errors/618964a1308b00000a0c130b/events\",\"unthrottled_occurrence_count\": 1,\"users\": 1,\"first_seen\": \"2021-11-08T17:55:45.000Z\",\"last_seen\": \"2021-11-08T17:55:45.000Z\",\"first_seen_unfiltered\": \"2021-11-08T17:55:45.000Z\",\"last_seen_unfiltered\": \"2021-11-08T17:55:45.733Z\",\"status\": \"open\",\"created_issue\": {\"id\": \"48180\",\"key\": \"XTP-53\",\"number\": 0,\"type\": \"jira\",\"url\": \"https://bugsnag.atlassian.net/browse/XTP-53\"},\"linked_issues\": [{\"id\": \"48180\",\"key\": \"XTP-53\",\"number\": 0,\"type\": \"jira\",\"url\": \"https://bugsnag.atlassian.net/browse/XTP-53\"}],\"reopen_rules\": null,\"assigned_collaborator_id\": null,\"comment_count\": 0,\"missing_dsyms\": [],\"release_stages\": [\"production\", \"development\"],\"grouping_reason\": \"frame-inner\",\"grouping_fields\": {\"file\": \"swift-ios\",\"relativeAddress\": \"0x4ee4\",\"errorClass\": \"Fatal error\"},\"url\": \"https://api.bugsnag.com/projects/5e4a9527ef8b1a000e53bed5/errors/618964a1308b00000a0c130b\",\"project_url\": \"https://api.bugsnag.com/projects/5e4a9527ef8b1a000e53bed5\"}"
        .data(using: .utf8)
    static let sampleErrorObject = try? JSONDecoder().decode(BSGError.self, from: sampleError!)
    static var previews: some View {
        ErrorTableRow(errorToRender: sampleErrorObject!)
.previewInterfaceOrientation(.portrait)
    }
}
