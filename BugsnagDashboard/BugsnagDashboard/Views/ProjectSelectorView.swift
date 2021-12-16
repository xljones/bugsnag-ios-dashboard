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
    
    @State private var noOrganizationShow: Bool
    @Binding var myProjects: [BSGProject]?
    @Binding var activeProject: ActiveProject?
    
    public init(myProjects: Binding<[BSGProject]?>, activeProject: Binding<ActiveProject?>) {
        _myProjects = myProjects
        _activeProject = activeProject
        _noOrganizationShow = State(initialValue: myOrganization == nil ? true : false)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Projects")
                    .font(.title)
                Button(action: {
                    print("Refresh project list")
                    if let organization = myOrganization {
                        getProjects(token: myToken, organization: organization) {
                            switch $0 {
                            case let .success(rtnProjects):
                                noOrganizationShow = false
                                myProjects = rtnProjects
                                print("getProjects Success")
                            case let .failure(error):
                                print("getProjects Failed: \(error)")
                            }
                        }
                    } else {
                        noOrganizationShow = true
                        print("Can't referesh projects, myOrganization is nil")
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20))
                        .foregroundColor(BSGPrimaryColors.indigo)
                        .frame(alignment:.trailing)
                }
                Spacer()
            }
            .padding(20)
            if noOrganizationShow {
                Text("No organization is set.")
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(BSGExtendedColors.batman40)
                    .background(BSGExtendedColors.batman00)
            }
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
                }
            }.background(BSGExtendedColors.batman00)
        }
        .onAppear {
            if let organization = myOrganization {
                if myProjects == nil {
                    getProjects(token: myToken, organization: organization) {
                        switch $0 {
                        case let .success(rtnProjects):
                            noOrganizationShow = false
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
    @State static var testActiveProject: ActiveProject?
    static var previews: some View {
        ProjectSelectorView(myProjects: $testProjects, activeProject: $testActiveProject)
    }
}
