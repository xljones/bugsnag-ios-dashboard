//
//  ProjectSelectorView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct ProjectSelectorView: View {
    @Environment(\.presentationMode) var thisView

    @Binding private var myProjects: [BSGProject]?
    @Binding private var myOrganization: BSGOrganization?
    @Binding private var activeProject: ActiveProject?
    
    public init(myProjects: Binding<[BSGProject]?>,
                myOrganization: Binding<BSGOrganization?>,
                activeProject: Binding<ActiveProject?>) {
        _myProjects = myProjects
        _myOrganization = myOrganization
        _activeProject = activeProject
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Projects")
                .font(.title)
                .frame(width: .infinity, alignment: .leading)
                .padding(20)
            List {
                if let projects = myProjects {
                    ForEach(Array(projects.enumerated()), id: \.offset) { index, project in
                        Button(action: {
                            print("Setting active project ID '\(project.id)', index \(index)")
                            activeProject = ActiveProject.init(index: index, details: project)
                            self.thisView.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                    .foregroundColor(project.id == activeProject?.details.id ? BSGSecondaryColors.coral : BSGPrimaryColors.indigo)
                                    .imageScale(.large)
                                Text(project.name)
                                    .foregroundColor(BSGPrimaryColors.midnight)
                                    .font(.subheadline)
                            }
                        }
                    }
                } else if myOrganization == nil {
                    Text("No organization is set")
                        .foregroundColor(BSGExtendedColors.batman40)
                } else {
                    Text("No projects in organization \(myOrganization!.name)")
                        .foregroundColor(BSGExtendedColors.batman40)
                }
            }
            .listStyle(GroupedListStyle())
            .background(BSGExtendedColors.batman00)
            .refreshable {
                print("Projects: Refresh project list")
                if let organization = myOrganization {
                    getProjects(token: myToken, organization: organization) {
                        switch $0 {
                        case let .success(rtnProjects):
                            myProjects = rtnProjects
                            print("getProjects Success")
                        case let .failure(error):
                            print("getProjects Failed: \(error)")
                        }
                    }
                } else {
                    print("Can't referesh projects, myOrganization is nil")
                }
            }
            Text("Pull to refresh")
                .foregroundColor(BSGExtendedColors.batman20)
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            if let organization = myOrganization {
                if myProjects == nil {
                    getProjects(token: myToken, organization: organization) {
                        switch $0 {
                        case let .success(rtnProjects):
                            myProjects = rtnProjects
                            print("getProjects Success (on init)")
                        case let .failure(error):
                            print("getProjects Failed (on init): \(error)")
                        }
                    }
                }
            }
        }
    }
}

struct ProjectSelectorView_Previews: PreviewProvider {
    // MARK: Must use statics in Previews: https://stackoverflow.com/questions/61753114/instance-member-cannot-be-used-on-type-in-swiftui-preview
    @State static var testProjects: [BSGProject]?
    @State static var testOrganization: BSGOrganization?
    @State static var testActiveProject: ActiveProject?
    static var previews: some View {
        ProjectSelectorView(myProjects: $testProjects, myOrganization: $testOrganization, activeProject: $testActiveProject)
    }
}
