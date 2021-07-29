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
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4),
        BSGError.init(id: UUID().uuidString, errorClass: "class2", errorMessage: "The operation couldn’t be completed. (bugsnag_example.ViewController.BadError error 1.)", errorContext: "ctx2", userCount: 3, eventCount: 4)
    ]
    
    public var body: some View {
        List {
            ForEach (errors, id: \.id) { e in
                ErrorListItem(error: e)
            }
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
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
