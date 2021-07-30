//
//  Organization.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

public class BSGToken {
    private var token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public func setToken(token: String) {
        self.token = token
    }
    
    public func getToken() -> String {
        return self.token
    }
}

public struct BSGOrganization {
    var id: String
    var name: String
    var slug: String
    
    public init(id: String,
                name: String,
                slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

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
