//
//  Common.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 20/12/2021.
//

import Foundation
import SwiftUI

public struct SheetTitle: View {
    var theTitle: String
    
    public init(title: String) {
        theTitle = title
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(theTitle)
                .font(.title)
        }.padding(20)
        Divider()
    }
}

public struct KeyValueRow: View {
    var key: String
    var value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(self.key).foregroundColor(Color.tertiaryLabel).font(.system(size:10))
            Text(self.value)
        }
    }
}
