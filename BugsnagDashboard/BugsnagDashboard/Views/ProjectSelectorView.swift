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
    
    @State private var ps: [BSGProject] = myProjects
    
    public init() {

    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Projects")
                    .font(.title)
                Button(action: {
                    print("Refresh project list")
                    if (myOrganization != nil) {
                        getProjects(token: myToken, organization: myOrganization!) {
                            switch $0 {
                            case let .success(projects):
                                ps = projects
                                print("getProjects Success")
                            case let .failure(error):
                                print("getProjects Failed: \(error)")
                            }
                        }
                    } else {
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
            .padding(.horizontal, 20.0)
            .padding(.top, 20.0)
            List {
                ForEach(ps, id: \.id) { p in
                    Button(action: {
                        print("Project \(p.id) selected")
                        self.thisView.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "qrcode")
                                .foregroundColor(BSGPrimaryColors.indigo)
                                .imageScale(.large)
                            Text(p.name)
                                .foregroundColor(BSGPrimaryColors.midnight)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .background(BSGExtendedColors.batman00)
        }
    }

}

struct ProjectSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSelectorView()
    }
}
