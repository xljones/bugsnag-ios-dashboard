//
//  Error.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: Error
public struct BSGError {
    public init(id: String,
                errorClass: String,
                errorMessage: String,
                errorContext: String,
                userCount: Int,
                eventCount: Int) {
        self.id = id
        self.errorClass = errorClass
        self.errorMessage = errorMessage
        self.errorContext = errorContext
        self.userCount = userCount
        self.eventCount = eventCount
    }
    var id: String
    var errorClass: String
    var errorMessage: String
    var errorContext: String
    var userCount: Int
    var eventCount: Int
}

// MARK: Event
public struct BSGEvent {
    public init(id: String,
                errorClass: String,
                errorMessage: String,
                errorContext: String) {
        self.id = id
        self.errorClass = errorClass
        self.errorMessage = errorMessage
        self.errorContext = errorContext
    }
    var id: String
    var errorClass: String
    var errorMessage: String
    var errorContext: String
}
