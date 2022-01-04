//
//  ReleasesView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct ReleasesView: View {
    @Binding var activeProject: ActiveProject?
    @State var releaseGroups: [BSGReleaseGroup]?
    @State var selectedReleaseStage: String?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    func refreshReleaseGroups() {
        if let project = activeProject {
            //selectedReleaseStage = project.details.releaseStages[0]
            getReleaseGroups(token: myToken,
                             project: project.details,
                             releaseStage: "production") {
                switch $0 {
                    case let .success(rtnReleaseGroups):
                    releaseGroups = rtnReleaseGroups
                    logMessage(message: releaseGroups as Any)
                    logMessage(message: "getReleaseGroups Success")
                case let .failure(error):
                    logMessage(message: "getReleaseGroups Failed: \(error)")
                }
            }
        }
    }
    
    public var body: some View {
        
        let navigationTitle: String = activeProject != nil ? activeProject!.details.name : "Releases"
        
        VStack(alignment: .leading, spacing: 0) {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        if let project = activeProject {
                            Picker("Select Release Stage", selection: $selectedReleaseStage) {
                                ForEach(project.details.releaseStages, id: \.self) { rlsStage in
                                    Text(rlsStage)
                                }
                            }
                            if let sel = selectedReleaseStage {
                                Text("Selected flavor: \(sel)")
                            }
                        }
                        if let rlsGroups = releaseGroups {
                            if (rlsGroups.count == 0) {
                                Text("No release groups on this project")
                                    .foregroundColor(Color.secondary)
                            } else {
                                ForEach(rlsGroups, id: \.id) { releaseGroup in
                                    NavigationLink(destination: Text("Here's the release view")) {
                                        ReleaseGroupRow(releaseGroupToRender: releaseGroup)
                                            .navigationBarBackButtonHidden(true)
                                    }
                                }
                            }
                        } else {
                            Text("No release available. Select a project first.")
                                .foregroundColor(Color.secondary)
                        }
                    }
                    .refreshable {
                        refreshReleaseGroups()
                    }
                    .listStyle(GroupedListStyle())
                }
                .navigationTitle(navigationTitle)
            }
        }
        .onAppear {
            refreshReleaseGroups()
        }
        .onChange(of: self.activeProject) { _ in
            refreshReleaseGroups()
        }
    }
}
    
struct ReleaseGroupRow: View {
    let releaseGroup: BSGReleaseGroup
    
    init(releaseGroupToRender: BSGReleaseGroup) {
        self.releaseGroup = releaseGroupToRender
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(releaseGroup.id)
            Text(releaseGroup.appVersion)
        }
        .font(.system(size:12))
        .foregroundColor(Color.primary)
    }
}

struct ReleasesView_Previews: PreviewProvider {
    @State static var testActiveProject: ActiveProject?
    static var previews: some View {
        ReleasesView(activeProject: $testActiveProject)
    }
}

struct ReleaseGroupRow_Previews: PreviewProvider {
    static let sampleReleaseGroupData = "{\"id\": \"61c1b8afd9e59e6c21009ae5\",\"project_id\": \"61c1b75a33201d000f4ce38d\",\"release_stage_name\": \"production\",\"app_version\": \"2.0.0\",\"first_released_at\": \"2021-12-21T11:21:19.898Z\",\"first_release_id\": \"61c1b8af407b02121aea17c0\",\"releases_count\": 1,\"has_secondary_versions\": false,\"build_tool\": \"\",\"builder_name\": \"\",\"source_control\": null,\"top_release_group\": true,\"visible\": true,\"total_sessions_count\": 3,\"unhandled_sessions_count\": 1,\"sessions_count_in_last_24h\": 0,\"accumulative_daily_users_seen\": 1,\"accumulative_daily_users_with_unhandled\": 1}"
        .data(using: .utf8)
    static let sampleReleaseGroupObject = try? JSONDecoder().decode(BSGReleaseGroup.self, from: sampleReleaseGroupData!)
    static var previews: some View {
        ReleaseGroupRow(releaseGroupToRender: sampleReleaseGroupObject!)
    }
}
