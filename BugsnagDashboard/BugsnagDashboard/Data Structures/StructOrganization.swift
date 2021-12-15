//
//  StructOrganization.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

// MARK: - Organizations
// MARK: Present: Swift is very strict on typing to ensure that without checking, you can never present a nil value
public struct BSGOrganization: Codable {
    var id, name, slug: String
    var creator: BSGOrganizationCreator?
    var collaboratorsURL, projectsURL: String?
    var createdAt, updatedAt: String?
    var autoUpgrade: Bool?
    var upgradeURL: String?
    var canStartProTrial: Bool?
    var proTrialEndsAt: String?
    var proTrialFeature: Bool?
    var billingEmails: [String]?
    
    init() {
        self.id = ""
        self.name = ""
        self.slug = ""
    }
}

// MARK: BSGOrganizationCreator
struct BSGOrganizationCreator: Codable {
    var id, name, email: String?
}
