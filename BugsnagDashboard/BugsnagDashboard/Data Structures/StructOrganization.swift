//
//  StructOrganization.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: - BSGOrganization
public struct BSGOrganization: Codable {
    let id, name, slug: String
    let creator: BSGOrganizationCreator
    let collaboratorsURL, projectsURL: String
    let createdAt, updatedAt: String
    let autoUpgrade: Bool
    let upgradeURL: String
    let canStartProTrial: Bool
    let proTrialEndsAt: String?
    let proTrialFeature: Bool
    let billingEmails: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, slug, creator
        case collaboratorsURL = "collaborators_url"
        case projectsURL = "projects_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case autoUpgrade = "auto_upgrade"
        case upgradeURL = "upgrade_url"
        case canStartProTrial = "can_start_pro_trial"
        case proTrialEndsAt = "pro_trial_ends_at"
        case proTrialFeature = "pro_trial_feature"
        case billingEmails = "billing_emails"
    }
}

// MARK: BSGOrganizationCreator
struct BSGOrganizationCreator: Codable {
    var id, name, email: String
}
