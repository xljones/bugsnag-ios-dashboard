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
    
    init(myProjects: Binding<[BSGProject]?>,
                myOrganization: Binding<BSGOrganization?>,
                activeProject: Binding<ActiveProject?>) {
        _myProjects = myProjects
        _myOrganization = myOrganization
        _activeProject = activeProject
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetTitle(title: "Projects")
            List {
                if let projects = myProjects {
                    ForEach(Array(projects.enumerated()), id: \.offset) { index, project in
                        Button(action: {
                            logMessage(message: "Setting active project ID '\(project.id)', index \(index)")
                            activeProject = ActiveProject.init(index: index, details: project)
                            self.thisView.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                    .foregroundColor(project.id == activeProject?.details.id ? BSGSecondaryColors.coral : BSGPrimaryColors.indigo)
                                    .imageScale(.large)
                                Text(project.name)
                                    .foregroundColor(Color.primary)
                            }
                        }
                    }
                } else if myOrganization == nil {
                    Text("No organization is set")
                        .foregroundColor(Color.secondary)
                } else {
                    Text("No projects in organization \(myOrganization!.name)")
                        .foregroundColor(Color.secondary)
                }
            }
            .listStyle(GroupedListStyle())
            .background(Color.gray)
            .refreshable {
                logMessage(message: "Projects: Refresh project list")
                if let organization = myOrganization {
                    getProjects(token: myToken, organization: organization) {
                        switch $0 {
                        case let .success(rtnProjects):
                            myProjects = rtnProjects
                            logMessage(message: "getProjects Success")
                        case let .failure(error):
                            logMessage(message: "getProjects Failed: \(error)")
                        }
                    }
                } else {
                    logMessage(message: "Can't referesh projects, myOrganization is nil")
                }
            }
            Text("Pull to refresh")
                .foregroundColor(Color.tertiaryLabel)
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
                            logMessage(message: "getProjects Success (on init)")
                        case let .failure(error):
                            logMessage(message: "getProjects Failed (on init): \(error)")
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
