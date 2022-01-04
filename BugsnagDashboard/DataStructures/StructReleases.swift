//
//  StructReleases.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 16/12/2021.
//

import Foundation

// MARK: - BSGReleaseGroup
public struct BSGReleaseGroup: Codable {
    let id, projectID, releaseStageName, appVersion: String
    let firstReleasedAt, firstReleaseID: String
    let releasesCount: Int
    let hasSecondaryVersions: Bool
    let buildTool, builderName: String
    let sourceControl: BSGReleaseGroupSourceControl?
    let topReleaseGroup, visible: Bool
    let totalSessionsCount, unhandledSessionsCount, sessionsCountInLast24H, accumulativeDailyUsersSeen: Int
    let accumulativeDailyUsersWithUnhandled: Int

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case releaseStageName = "release_stage_name"
        case appVersion = "app_version"
        case firstReleasedAt = "first_released_at"
        case firstReleaseID = "first_release_id"
        case releasesCount = "releases_count"
        case hasSecondaryVersions = "has_secondary_versions"
        case buildTool = "build_tool"
        case builderName = "builder_name"
        case sourceControl = "source_control"
        case topReleaseGroup = "top_release_group"
        case visible
        case totalSessionsCount = "total_sessions_count"
        case unhandledSessionsCount = "unhandled_sessions_count"
        case sessionsCountInLast24H = "sessions_count_in_last_24h"
        case accumulativeDailyUsersSeen = "accumulative_daily_users_seen"
        case accumulativeDailyUsersWithUnhandled = "accumulative_daily_users_with_unhandled"
    }
}

struct BSGReleaseGroupSourceControl: Codable {
    let service: String
    let commitURL: String
    let revision: String
    let diffURLToPrevious: String
    let previousAppVersion: String
    
    enum CodingKeys: String, CodingKey {
        case service
        case commitURL = "commit_url"
        case revision
        case diffURLToPrevious = "diff_url_to_previous"
        case previousAppVersion = "previous_app_version"
    }
}

// MARK: - BSGRelease
public struct BSGRelease: Codable {
    let id, projectID: String
    let releaseTime: Date
    let releaseSource, appVersion, appVersionCode, appBundleVersion: String
    let buildLabel, builderName, buildTool: String
    let errorsIntroducedCount, errorsSeenCount, sessionsCountInLast24H, totalSessionsCount: Int
    let unhandledSessionsCount, accumulativeDailyUsersSeen, accumulativeDailyUsersWithUnhandled: Int
    let metadata: BSGReleaseMetadata
    let releaseStage: BSGReleaseReleaseStage
    let sourceControl: BSGReleaseSourceControl
    let releaseGroupID: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case releaseTime = "release_time"
        case releaseSource = "release_source"
        case appVersion = "app_version"
        case appVersionCode = "app_version_code"
        case appBundleVersion = "app_bundle_version"
        case buildLabel = "build_label"
        case builderName = "builder_name"
        case buildTool = "build_tool"
        case errorsIntroducedCount = "errors_introduced_count"
        case errorsSeenCount = "errors_seen_count"
        case sessionsCountInLast24H = "sessions_count_in_last_24h"
        case totalSessionsCount = "total_sessions_count"
        case unhandledSessionsCount = "unhandled_sessions_count"
        case accumulativeDailyUsersSeen = "accumulative_daily_users_seen"
        case accumulativeDailyUsersWithUnhandled = "accumulative_daily_users_with_unhandled"
        case metadata
        case releaseStage = "release_stage"
        case sourceControl = "source_control"
        case releaseGroupID = "release_group_id"
    }
}

// MARK: - BSGReleaseGroupMetadata
struct BSGReleaseMetadata: Codable {
}

// MARK: - BSGReleaseGroupReleaseStage
struct BSGReleaseReleaseStage: Codable {
    let name: String
}

// MARK: - BSGReleaseGroupSourceControl
struct BSGReleaseSourceControl: Codable {
    let service, commitURL, revision, diffURLToPrevious: String

    enum CodingKeys: String, CodingKey {
        case service
        case commitURL = "commit_url"
        case revision
        case diffURLToPrevious = "diff_url_to_previous"
    }
}
