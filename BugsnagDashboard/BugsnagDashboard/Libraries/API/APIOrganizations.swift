//
//  APIOrganizations.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation

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
