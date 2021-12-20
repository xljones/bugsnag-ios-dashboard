//
//  StructUser.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 09/12/2021.
//

import Foundation

// MARK: BSGToken
public class BSGToken {
    private var token: String
    var tokenKey = "BUGSNAG_DAA_TOKEN"
    let defaults = UserDefaults.standard
    
    public init(token: String? = nil) {
        if token != nil {
            self.token = token!
        } else {
            self.token = defaults.object(forKey: tokenKey) as? String ?? ""
        }
    }
    
    public func setToken(token: String) {
        self.token = token
        defaults.set(token, forKey: tokenKey)
    }
    
    public func getToken() -> String {
        return self.token
    }
    
    public func isValid() -> Bool {
        if self.token.count == 36 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - BSGUser
public struct BSGUser: Codable {
    let id, name, email: String
    let twoFactorEnabled: Bool
    let twoFactorEnabledOn, passwordUpdatedOn: String
    let showTimeInUTC, heroku: Bool
    let recoveryCodesRemaining: Int
    let createdAt: String
    let favoriteProjectIDS: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case twoFactorEnabled = "two_factor_enabled"
        case twoFactorEnabledOn = "two_factor_enabled_on"
        case passwordUpdatedOn = "password_updated_on"
        case showTimeInUTC = "show_time_in_utc"
        case heroku
        case recoveryCodesRemaining = "recovery_codes_remaining"
        case createdAt = "created_at"
        case favoriteProjectIDS = "favorite_project_ids"
    }
}
