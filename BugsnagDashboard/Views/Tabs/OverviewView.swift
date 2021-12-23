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
        let navigationTitle: String = activeProject != nil ? activeProject!.details.name : "Overview"
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
    private var stability: BSGProjectStability
    
    @State private var selectedIndex: Int

    init(stabilityToRender: BSGProjectStability) {
        self.stability = stabilityToRender
        self.selectedIndex = stabilityToRender.timelinePoints.count - 1
    }
    
    var body: some View {
        KeyValueRow(key: "primary release stage", value: stability.releaseStageName)
        SessionStabilityChartView(timelinePointsToRender: stability.timelinePoints,
                                  selectedIndex: $selectedIndex)
        KeyValueRow(key: "", value: stability.timelinePoints[selectedIndex].bucketStart)
        KeyValueRow(key: "session stability", value: String("\(calcStabilityPercentage(unhandledRate: stability.timelinePoints[selectedIndex].unhandledRate))%"))
    }
}

struct SessionStabilityChartView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding private var selectedIndex: Int
    
    @State var selectedXPos: CGFloat = 8 // User X touch location
    @State var selectedYPos: CGFloat = 0 // User Y touch location
    @State var isSelected: Bool = false // Is the user touching the graph
    
    private var stabilityPlot: [CGFloat] = []
    private var minStabilityValue: CGFloat = 0
    private var maxStabilityValue: CGFloat = 100
    private var minChartHeight: CGFloat = 0
    private var maxChartHeight: CGFloat = 100
    
    public init(timelinePointsToRender: [BSGProjectStabilityTimelinePoint],
                selectedIndex: Binding<Int>) {
        /// Apply bindings
        _selectedIndex = selectedIndex
        
        /// Initialize values
        timelinePointsToRender.enumerated().forEach() { index, timelinePoint in
            let sessionStability: CGFloat = calcStabilityPercentage(unhandledRate: timelinePoint.unhandledRate)
            stabilityPlot.append(sessionStability)
        }
        minStabilityValue = stabilityPlot.reduce(0, { currentMin, point in
            min(currentMin, point)
        })
        maxStabilityValue = stabilityPlot.reduce(0, { currentMax, point in
            max(currentMax, point)
        })
    }
    
    var body: some View {
        ZStack() {
            drawGrid()
                .opacity(0.2)
                .overlay(drawChart())
                //.overlay(drawTargetStability())
                .overlay(drawPoints())
                .overlay(userInteraction())
        }
        .padding(.top, 10)
    }
    
    private func drawGrid() -> some View {
        let lineWidth: CGFloat = 1
        
        return VStack(spacing: 0) {
            Color.primary.frame(height: 1, alignment: .center)
            HStack(spacing: 0) {
                ForEach(0..<stabilityPlot.count - 1) { _ in
                    Color.primary.frame(width: lineWidth, height: 150, alignment: .center)
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
                let scale = geo.size.height / maxChartHeight
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
            let circleDiameter: CGFloat = 4
            let scale: CGFloat = geo.size.height / maxChartHeight
            ForEach(stabilityPlot.indices, id: \.self) { index in
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
                    .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                    .foregroundColor(colorScheme == .light ? BSGPrimaryColors.indigo : BSGSecondaryColors.coral)
                    .background(Color.white)
                    .offset(x: (geo.size.width / CGFloat(stabilityPlot.count - 1) * CGFloat(index) - (circleDiameter/2)),
                            y: (geo.size.height - (stabilityPlot[index] * scale)) - (circleDiameter/2))
            }
        }
    }
    
    private func userInteraction() -> some View {
        GeometryReader { geo in
            let scale = geo.size.height / maxChartHeight
            let highlightColor: Color = colorScheme == .light ? BSGSecondaryColors.orchid : BSGSecondaryColors.orchid
            let lineWidth: CGFloat = 2
            let circleDiameter: CGFloat = 12
            ZStack(alignment: .leading) {
                Group {
                    Color(highlightColor.cgColor!)
                        .frame(width: lineWidth)
                    Group {
                        Circle()
                            .frame(width: circleDiameter * 2, height: circleDiameter * 2, alignment: .center)
                            .foregroundColor(Color.primary)
                            .opacity(0.2)
                            .offset(x: -circleDiameter, y: 0)
                        Circle()
                            .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                            .foregroundColor(highlightColor)
                            .offset(x: -(circleDiameter/2), y: 0)
                    }
                    .offset(x: 1, y: -(geo.size.height/2) + (geo.size.height - (stabilityPlot[selectedIndex] * scale)))
                }
                .offset(x: (geo.size.width / CGFloat(stabilityPlot.count - 1) * CGFloat(selectedIndex)) - (lineWidth / 2), y: 0)
                .animation(Animation.spring(), value: 4)
                
                Color.white.opacity(0.01)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { touch in
                                let xPos = touch.location.x
                                self.isSelected = true
                                let index = xPos / (geo.size.width / CGFloat(stabilityPlot.count))

                                if index > 0 && index < CGFloat(stabilityPlot.count) {
                                    self.selectedIndex = Int(index)
                                }
                                
                            }
                            .onEnded { touch in
                                self.isSelected = false
                            }
                    )
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

struct SessionStabilityChartPreview: PreviewProvider {
    static let testStabilitySampleData = "{\"project_id\":\"5e4a9527ef8b1a000e53bed5\",\"release_stage_name\":\"development\",\"timeline_points\":[{\"bucket_start\":\"2021-11-22T00:00:00.000Z\",\"bucket_end\":\"2021-11-23T00:00:00.000Z\",\"total_sessions_count\":100,\"unhandled_sessions_count\":1,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-23T00:00:00.000Z\",\"bucket_end\":\"2021-11-24T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.12,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-24T00:00:00.000Z\",\"bucket_end\":\"2021-11-25T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.05,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-25T00:00:00.000Z\",\"bucket_end\":\"2021-11-26T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-26T00:00:00.000Z\",\"bucket_end\":\"2021-11-27T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-27T00:00:00.000Z\",\"bucket_end\":\"2021-11-28T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-28T00:00:00.000Z\",\"bucket_end\":\"2021-11-29T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-29T00:00:00.000Z\",\"bucket_end\":\"2021-11-30T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.2,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-11-30T00:00:00.000Z\",\"bucket_end\":\"2021-12-01T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-01T00:00:00.000Z\",\"bucket_end\":\"2021-12-02T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-02T00:00:00.000Z\",\"bucket_end\":\"2021-12-03T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.3,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-03T00:00:00.000Z\",\"bucket_end\":\"2021-12-04T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-04T00:00:00.000Z\",\"bucket_end\":\"2021-12-05T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-05T00:00:00.000Z\",\"bucket_end\":\"2021-12-06T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.25,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-06T00:00:00.000Z\",\"bucket_end\":\"2021-12-07T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-07T00:00:00.000Z\",\"bucket_end\":\"2021-12-08T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-08T00:00:00.000Z\",\"bucket_end\":\"2021-12-09T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-09T00:00:00.000Z\",\"bucket_end\":\"2021-12-10T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-10T00:00:00.000Z\",\"bucket_end\":\"2021-12-11T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-11T00:00:00.000Z\",\"bucket_end\":\"2021-12-12T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.22,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-12T00:00:00.000Z\",\"bucket_end\":\"2021-12-13T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.11,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-13T00:00:00.000Z\",\"bucket_end\":\"2021-12-14T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.12,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-14T00:00:00.000Z\",\"bucket_end\":\"2021-12-15T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.13,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-15T00:00:00.000Z\",\"bucket_end\":\"2021-12-16T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-16T00:00:00.000Z\",\"bucket_end\":\"2021-12-17T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.13,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-17T00:00:00.000Z\",\"bucket_end\":\"2021-12-18T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-18T00:00:00.000Z\",\"bucket_end\":\"2021-12-19T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.08,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-19T00:00:00.000Z\",\"bucket_end\":\"2021-12-20T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.07,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-20T00:00:00.000Z\",\"bucket_end\":\"2021-12-21T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.1,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0},{\"bucket_start\":\"2021-12-21T00:00:00.000Z\",\"bucket_end\":\"2021-12-22T00:00:00.000Z\",\"total_sessions_count\":0,\"unhandled_sessions_count\":0,\"unhandled_rate\":0.2,\"users_seen\":0,\"users_with_unhandled\":0,\"unhandled_user_rate\":0}]}"
        .data(using: .utf8)
    static let sampleStabilityData = try? JSONDecoder().decode(BSGProjectStability.self, from: testStabilitySampleData!)
    @State static var testSelectedIndex: Int = 10
    static var previews: some View {
        SessionStabilityChartView(timelinePointsToRender: sampleStabilityData!.timelinePoints, selectedIndex: $testSelectedIndex)
    }
}
