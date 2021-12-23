//
//  APIUser.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 15/12/2021.
//

import Foundation

// MARK: - Get User and related Organization
func getUserAndOrganization(token: BSGToken,
                            callback: @escaping (_ rtnUser: BSGUser?, _ rtnOrganization: BSGOrganization?) -> Void) {
    
    var testUser: BSGUser?
    var testOrganization: BSGOrganization?

    let group = DispatchGroup()

    group.enter()
    getUser(token: token) {
        switch $0 {
        case let .success(user):
            testUser = user
            logMessage(message: "Test: getUser Success")
        case let .failure(error):
            logMessage(message: "Test: getUser Failed: \(error)")
        }
        group.leave()
    }
    
    group.enter()
    getOrganizations(token: token) {
        switch $0 {
        case let .success(orgs):
            testOrganization = orgs[0]
            logMessage(message: "Test: getOrganizations Success")
        case let .failure(error):
            logMessage(message: "Test: getOrganizations Failed: \(error)")
        }
        group.leave()
    }

    group.notify(queue: DispatchQueue.main) {
        if let testUser = testUser, let testOrganization = testOrganization {
            callback(testUser, testOrganization)
        } else {
            callback(nil, nil)
        }
    }
}

// MARK: -  Get Organizations
public func getOrganizations(token: BSGToken,
                             completionHandler: @escaping (Result<[BSGOrganization], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/user/organizations")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let orgs = try JSONDecoder().decode([BSGOrganization].self, from: data)
            completionHandler(.success(orgs))
        } catch {
            completionHandler(.failure(error))
        }
    }.resume()
}

// MARK: - Get User
public func getUser(token: BSGToken,
                    completionHandler: @escaping (Result<BSGUser, Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/user")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let user = try JSONDecoder().decode(BSGUser.self, from: data)
            completionHandler(.success(user))
        } catch {
            completionHandler(.failure(error))
        }
    }.resume()
}
