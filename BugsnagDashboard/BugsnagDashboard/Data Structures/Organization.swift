//
//  Organization.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
public struct BSGOrganization {
    public init(id: String,
                name: String){
        self.id = id
        self.name = name
    }
    var id: String
    var name: String
}

public struct BSGProject {
    public init(id: String,
                name: String,
                type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
    var id: String
    var name: String
    var type: String
}
