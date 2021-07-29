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
    
    var projects = [
        BSGProject.init(id: UUID().uuidString, name: "Android", type: "android"),
        BSGProject.init(id: UUID().uuidString, name: "iOS", type: "ios")
    ]
    
    public init() {
    }
    
    public var body: some View {
        Text("Bugsnag Projects")
            .font(.headline)
            .padding(20)
        List {
            ForEach(projects, id: \.id) { p in
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
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BSGExtendedColors.batman00)
    }

}

struct ProjectSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSelectorView()
    }
}
