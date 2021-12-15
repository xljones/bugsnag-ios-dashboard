//
//  StructUser.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 09/12/2021.
//

import Foundation

// MARK: Token
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

// MARK: User
public struct BSGUser: Codable {
    var id, name, email: String
    var twoFactorEnabled: Bool?
    var twoFactorEnabledOn, passwordUpdatedOn: String?
    var showTimeInUTC, heroku: Bool?
    var recoveryCodesRemaining: Int?
    var createdAt: String?
    var favoriteProjectIDS: [String]?
    
    init() {
        self.id = ""
        self.name = ""
        self.email = ""
    }
}
