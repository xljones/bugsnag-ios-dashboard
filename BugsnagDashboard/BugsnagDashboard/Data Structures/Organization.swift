//
//  Organization.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: Organizations
public struct BSGOrganization: Codable {
    let id, name, slug: String
    let creator: BSGOrganizationCreator?
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

struct BSGOrganizationCreator: Codable {
    let id, name, email: String
}

// MARK: Projects
public struct BSGProject {
    var id: String
    var name: String
    var type: String
    
    public init(id: String,
                name: String,
                type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
}
