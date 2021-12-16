//
//  StructError.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: - BSGError
public struct BSGError: Codable {
    let id, projectID: String
    let errorClass, message, context: String
    let severity, originalSeverity: String
    let overriddenSeverity: String?
    let events: Int
    let eventsURL: String
    let unthrottledOccurrenceCount, users: Int
    let firstSeen, lastSeen, firstSeenUnfiltered, lastSeenUnfiltered: String
    let status: String
    // let createdIssue: BSGErrorLinkedIssues // Ignore this fields, it's duplicared by `linkedIssues`
    let linkedIssues: [BSGErrorLinkedIssues]
    let reopenRules: BSGErrorReopenRules?
    let assignedCollaboratorID: String?
    let commentCount: Int
    let missingDsyms: [String]?
    let releaseStages: [String]?
    let groupingReason: String?
    let groupingFields: BSGErrorGroupingFields
    let url, projectURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case errorClass = "error_class"
        case message, context, severity
        case originalSeverity = "original_severity"
        case overriddenSeverity = "overridden_severity"
        case events
        case eventsURL = "events_url"
        case unthrottledOccurrenceCount = "unthrottled_occurrence_count"
        case users
        case firstSeen = "first_seen"
        case lastSeen = "last_seen"
        case firstSeenUnfiltered = "first_seen_unfiltered"
        case lastSeenUnfiltered = "last_seen_unfiltered"
        case status
        // case createdIssue = "created_issue"
        case linkedIssues = "linked_issues"
        case reopenRules = "reopen_rules"
        case assignedCollaboratorID = "assigned_collaborator_id"
        case commentCount = "comment_count"
        case missingDsyms = "missing_dsyms"
        case releaseStages = "release_stages"
        case groupingReason = "grouping_reason"
        case groupingFields = "grouping_fields"
        case url
        case projectURL = "project_url"
    }
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

// MARK: - BSGErrorReopenRules
struct BSGErrorReopenRules: Codable {
    let reopenIf: String?
    let additionalOccurences, occurenceThreshold: Int
    
    enum CodingKeys: String, CodingKey {
        case reopenIf = "reopen_if"
        case additionalOccurences = "additional_occurrences"
        case occurenceThreshold = "occurrence_threshold"
    }
}
