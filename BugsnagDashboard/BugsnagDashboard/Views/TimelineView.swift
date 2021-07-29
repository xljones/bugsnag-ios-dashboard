//
//  TimelineView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct TimelineView: View {
    public init() {
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Project Name")
                .font(.title)
                .padding(.horizontal, 20.0)
                .padding(.top, 10.0)
            Divider()
                .frame(height:1)
                .background(BSGSecondaryColors.coral)
            Text("Timeline Goes here")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
