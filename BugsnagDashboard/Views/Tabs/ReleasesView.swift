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
    //@State var releases: [BSGRelease]?
    
    public init(activeProject: Binding<ActiveProject?>) {
        _activeProject = activeProject
    }
    
    func refreshReleases() {
        if let _ = activeProject {
            // refresh releases here.
        }
    }
    
    public var body: some View {
        let navigationTitle: String = activeProject != nil ? activeProject!.details.name : "Releases"
        
        VStack(alignment: .leading, spacing: 0) {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        Text("Not implemented yet :-(")
                            .foregroundColor(Color.secondary)
                    }
                    .refreshable {
                        refreshReleases()
                    }
                    .listStyle(GroupedListStyle())
                    .onAppear {
                        refreshReleases()
                    }
                }
                .navigationTitle(navigationTitle)
            }
        }
    }
}

struct ReleasesView_Previews: PreviewProvider {
    @State static var testActiveProject: ActiveProject?
    static var previews: some View {
        ReleasesView(activeProject: $testActiveProject)
    }
}
