//
//  StructError.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: - BSGError
public struct BSGError: Codable {
    let id: String
    let projectID: String
    let errorClass, message, context: String
    let severity, originalSeverity: String
    let overriddenSeverity: String?
    let eventsURL: String
    let events, unthrottledOccurrenceCount, users: Int
    let firstSeen, lastSeen, firstSeenUnfiltered, lastSeenUnfiltered: String
    let status: String?
    let createdIssue: String?
    let linkedIssues: [BSGErrorLinkedIssues]?
    let assignedCollaboratorID: String?
    let commentCount: Int?
    let missingDsyms: [String]?
    let releaseStages: [String]?
    let groupingReason: String?
    let groupingFields: BSGErrorGroupingFields?
    let url, projectURL: String?
}

// MARK: - BSGErrorGroupingFields
struct BSGErrorGroupingFields: Codable {
    let file, relativeAddress: String?
    let errorClass: String?
    let domain, method: String?
    let lineNumber: Int?
}

// MARK: - BSGErrorLinkedIssues
struct BSGErrorLinkedIssues: Codable {
    let id, key, type, url: String?
    let number: Int?
}
