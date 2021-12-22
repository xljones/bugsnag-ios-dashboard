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
    @State var projectStability: BSGProjectStability?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    func refreshOverview() {
        refreshStability()
        refreshProjectOverview()
    }
    
    func refreshStability() {
        if let project = activeProject {
            getProjectStability(token: myToken, project: project.details) {
                switch $0 {
                case let .success(rtnProjectStability):
                    projectStability = rtnProjectStability
                    print("getProjectStability Success")
                case let .failure(error):
                    projectStability = nil
                    print("getProjectStability Failed: \(error)")
                }
            }
        }
    }
    
    func refreshProjectOverview() {
        if let project = activeProject {
            getProjectOverview(token: myToken, project: project.details, completionHandler: {
                switch $0 {
                case let .success(rtnProjectOverview):
                    projectOverview = rtnProjectOverview
                    print("getProjectOverview Success")
                case let .failure(error):
                    projectOverview = nil
                    print("getProjectOverview Failed: \(error)")
                }
            })
        }
    }
    
    public var body: some View {
        let navigationTitle: String = activeProject != nil ? activeProject!.details.name : "<Select Project>"
        VStack(alignment: .leading, spacing: 0) {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        if let overview = projectOverview {
                            Section(header: Text("Information")) {
                                VStack(alignment: .leading) {
                                    Text("id").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                    Text(overview.projectID)
                                }
                            }
                            if let stability = projectStability {
                                Section(header: Text("Stability")) {
                                    ProjectStabilityView(stabilityToRender: stability)
                                }
                            }
                            Section(header: Text("Errors For Review")) {
                                VStack(alignment: .leading) {
                                    Text("current").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                    Text(String(overview.forReview.current))
                                }
                                VStack(alignment: .leading) {
                                    Text("one week ago").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                    Text(String(overview.forReview.oneWeekAgo))
                                }
                            }
                            Section(header: Text("Latest Release")) {
                                if let latestRelease = overview.latestRelease {
                                    VStack(alignment: .leading) {
                                        Text("release group id").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                        Text(latestRelease.releaseGroupId)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("first release time").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                        Text(latestRelease.firstReleaseTime)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("app version").foregroundColor(Color.tertiaryLabel).font(.system(size:10))
                                        Text(latestRelease.appVersion)
                                    }
                                } else {
                                    Text("No latest release for this project.")
                                        .foregroundColor(Color.secondary)
                                }
                            }
                        } else {
                            Text("No overview available, select a project first.")
                                .foregroundColor(Color.secondary)
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
                .navigationTitle(navigationTitle)
            }
        }
    }
}

struct ProjectStabilityView: View {
    @State var stability: BSGProjectStability

    init(stabilityToRender: BSGProjectStability) {
        self.stability = stabilityToRender
    }
    
    var body: some View {
        KeyValueRow(key: "primary release stage", value: stability.releaseStageName)
        SessionStabilityChartView(timelinePointsToRender: stability.timelinePoints)
//        ForEach(stability.timelinePoints, id: \.bucketStart) { timelinePoint in
//            let sessionStability: Double = ((1 - timelinePoint.unhandledRate) * 1000).rounded() / 10
//            let userStability: Double = ((1 - timelinePoint.unhandledUserRate) * 1000).rounded() / 10
//            KeyValueRow(key: friendlyFirstLastSeenTimestamp(firstSeenIso8601Timestamp: timelinePoint.bucketStart,
//                                                            lastSeenIso8601Timestamp: timelinePoint.bucketEnd),
//                        value: "S \(String(sessionStability))%, U \(String(userStability))%")
//        }
    }
}

struct SessionStabilityChartView: View {
    @Environment(\.colorScheme) var colorScheme
    //@Binding var selectedIndex: Int
    
    private var stabilityPlot: [CGFloat] = []
    private var minStabilityValue: CGFloat = 0
    private var maxStabilityValue: CGFloat = 100
    
    public init(timelinePointsToRender: [BSGProjectStabilityTimelinePoint]) {
                //selectedIndex: Binding<Int>
        timelinePointsToRender.enumerated().forEach() { index, timelinePoint in
            let sessionStability: CGFloat = ((1 - timelinePoint.unhandledRate) * 1000).rounded() / 10
            stabilityPlot.append(sessionStability)
        }
        minStabilityValue = stabilityPlot.reduce(0, { currentMin, point in
            min(currentMin, point)
        })
        maxStabilityValue = stabilityPlot.reduce(0, { currentMax, point in
            max(currentMax, point)
        })
        //self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        ZStack() {
            drawGrid()
                .opacity(0.2)
            .overlay(drawChart())
            .overlay(drawPoints())
                //.overlay(addUserInteraction(logs: logs))
        }
    }
    
    private func calcMinMaxValues() {

    }
    
    private func drawGrid() -> some View {
        VStack(spacing: 0) {
            Color.primary.frame(height: 1, alignment: .center)
            HStack(spacing: 0) {
                ForEach(0..<stabilityPlot.count) { _ in
                    Color.primary.frame(width: 1, height: 150, alignment: .center)
                    Spacer()
                }
                Color.primary.frame(width: 1, height: 150, alignment: .center)
            }
            Color.primary.frame(height: 1, alignment: .center)
        }
    }
    
    private func drawChart() -> some View {
        GeometryReader { geo in
            Path { path in
                let scale = geo.size.height / maxStabilityValue
                path.move(to: CGPoint(x: 0, y: geo.size.height - (CGFloat(stabilityPlot[0] * scale))))
                stabilityPlot.enumerated().forEach() { index, point in
                    if index != 0 {
                        path.addLine(to: CGPoint(x: (geo.size.width / CGFloat(stabilityPlot.count - 1) * CGFloat(index)),
                                                 y: geo.size.height - (point * scale)))
                    }
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .foregroundColor(colorScheme == .light ? BSGPrimaryColors.indigo : BSGSecondaryColors.coral)
        }
    }
    
    private func drawPoints() -> some View {
        GeometryReader { geo in
            Path { path in
                let scale = geo.size.height / maxStabilityValue
                ForEach(stabilityPlot.indices) { index in
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
                        .frame(width: 5, height: 5, alignment: .center)
                        .foregroundColor(colorScheme == .light ? BSGPrimaryColors.indigo : BSGSecondaryColors.coral)
                        .background(Color.white)
                        .cornerRadius(5)
                        .offset(x: (geo.size.width / CGFloat(stabilityPlot.count - 1) * CGFloat(index)),
                                y: (geo.size.height - (stabilityPlot[index] * scale)) - 5)
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
