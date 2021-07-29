//
//  InboxView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct InboxView: View {
    public init() { }
    
    // Use a temporary static error list for now.
    var errors: [BSGError] = [
        BSGError.init(id: UUID().uuidString, errorClass: "java.lang.Exception", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "bugsnag_example.ViewController.BadError (1)", userCount: 300, eventCount: 800),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "java.lang.Exception", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "bugsnag_example.ViewController.BadError (1)", userCount: 300, eventCount: 800),
        BSGError.init(id: UUID().uuidString, errorClass: "__SwiftNativeError", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4)
    ]
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Project Name")
                .font(.title)
                .padding(.horizontal, 20.0)
                .padding(.top, 10.0)
            Divider()
                .frame(height:1)
                .background(BSGSecondaryColors.coral)
            List {
                ForEach (errors, id: \.id) { e in
                    ErrorListItem(error: e)
                }
            }.padding(0)
        }
    }
}

struct ErrorListItem: View {
    var error: BSGError
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(error.errorClass)
                    .bold()
                Text(error.errorContext)
            }
            Text(error.errorMessage)
                .foregroundColor(BSGExtendedColors.batman30)
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
