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
    
    // MARK: These CodingKeys allow translation between what we want to call the key, and what the API calls the key.
    //       Some have the same name, e.g. `id`.
    enum CodingKeys: String, CodingKey {
        case id
        case organizationID = "organization_id"
        case slug, name
        case apiKey = "api_key"
        case type
        case isFullView = "is_full_view"
        case releaseStages = "release_stages"
        case language
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case errorsURL = "errors_url"
        case eventsURL = "events_url"
        case url
        case htmlURL = "html_url"
        case openErrorCount = "open_error_count"
        case forReviewErrorCount = "for_review_error_count"
        case collaboratorsCount = "collaborators_count"
        case globalGrouping = "global_grouping"
        case locationGrouping = "location_grouping"
        case discardedAppVersions = "discarded_app_versions"
        case discardedErrors = "discarded_errors"
        case customEventFieldsUsed = "custom_event_fields_used"
        case resolveOnDeploy = "resolve_on_deploy"
        case urlWhitelist = "url_whitelist"
        case ignoreOldBrowsers = "ignore_old_browsers"
    }
}

// MARK: - ActiveProject
public struct ActiveProject {
    var index: Int
    var details: BSGProject
}

// MARK: - BSGProjectOverview
public struct BSGProjectOverview: Codable {
    let projectID: String
    let forReview: BSGProjectOverviewForReview
    let latestRelease: BSGProjectOverviewLatestRelease?

    enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case forReview = "for_review"
        case latestRelease = "latest_release"
    }
}

// MARK: - BSGProjectOverviewForReview
struct BSGProjectOverviewForReview: Codable {
    let oneWeekAgo: Int
    let current: Int
    
    enum CodingKeys: String, CodingKey {
        case oneWeekAgo = "one_week_ago"
        case current
    }
}

// MARK: - BSGProjectOverviewLatestRelease
struct BSGProjectOverviewLatestRelease: Codable {
    let releaseGroupId: String
    let appVersion: String
    let firstReleaseTime: String
    
    enum CodingKeys: String, CodingKey {
        case releaseGroupId = "release_group_id"
        case appVersion = "app_version"
        case firstReleaseTime = "first_release_time"
    }
}
