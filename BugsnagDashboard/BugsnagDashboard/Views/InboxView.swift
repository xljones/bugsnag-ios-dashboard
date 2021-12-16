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
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let project = activeProject {
                Text(project.details.name)
                    .font(.title)
                    .padding(.horizontal, 20.0)
                    .padding(.top, 10.0)
                errorListContainerView
            }
        }
        .padding(0)
        .onAppear {
                if let project = activeProject {
                    getErrors(token: myToken, project: project.details) {
                        switch $0 {
                        case let .success(rtnErrors):
                            latestErrors = rtnErrors
                            print("getErrors Success (on appear)")
                        case let .failure(error):
                            print("getProjects Failed (on appear): \(error)")
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    public var errorListContainerView: some View {
        if let _ = latestErrors {
            errorListView
        } else {
            emptyErrorListView
        }
    }
    
    var emptyErrorListView: some View {
        Text("No errors.")
    }
    
    var errorListView: some View {
        List(latestErrors!, id: \.id) { err in
            VStack(alignment: .leading) {
                HStack {
                    Text(err.errorClass)
                        .bold()
                    Text(err.context)
                }
                Text(err.message)
                    .foregroundColor(BSGExtendedColors.batman30)
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    @State static var testActiveProject: ActiveProject?
    static var previews: some View {
        InboxView(activeProject: $testActiveProject)
    }
}
