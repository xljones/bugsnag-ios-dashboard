//
//  APIProjects.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 15/12/2021.
//

import Foundation

public func getProjects(token: BSGToken,
                        organization: BSGOrganization,
                        completionHandler: @escaping (Result<[BSGProject], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/organizations/\(organization.id)/projects")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    print("Projects: getting project list with organization ID: \(organization.id)")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let projects = try JSONDecoder().decode([BSGProject].self, from: data)
            completionHandler(.success(projects))
        } catch {
            do {
                // failed to map the returned JSON to the expected type, so inspect the payload
                let returnedJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(returnedJson)
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }.resume()
}
