//
//  StructProject.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 15/12/2021.
//

import Foundation

// MARK: - BSGProject
public struct BSGProject: Codable {
    let id, organizationID, slug, name: String
    let apiKey, type: String
    let isFullView: Bool
    let releaseStages: [String]
    let language: String?
    let createdAt, updatedAt: String
    let errorsURL, eventsURL, url, htmlURL: String
    let openErrorCount, forReviewErrorCount, collaboratorsCount: Int
    let globalGrouping, locationGrouping, discardedAppVersions, discardedErrors: [String]?
    let customEventFieldsUsed: Int
    let resolveOnDeploy: Bool
    let urlWhitelist: [String]?
    let ignoreOldBrowsers: Bool?
    let ignoredBrowserVersions: [String]?
}
