//
//  APIProjects.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 15/12/2021.
//

import Foundation

// MARK: - Get Projects
public func getProjects(token: BSGToken,
                        organization: BSGOrganization,
                        completionHandler: @escaping (Result<[BSGProject], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/organizations/\(organization.id)/projects?per_page=100")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    logMessage(message: "Projects: getting project list with organization ID: \(organization.id)")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let projects = try JSONDecoder().decode([BSGProject].self, from: data)
            completionHandler(.success(projects))
        } catch {
            do {
                // failed to map the returned JSON to the expected type, so inspect the payload
                let returnedJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                logMessage(message: returnedJson as Any)
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }.resume()
}

// MARK: - Get Project Overview
public func getProjectOverview(token: BSGToken,
                               project: BSGProject,
                               releaseStage: String = "production",
                               completionHandler: @escaping (Result<BSGProjectOverview, Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/projects/\(project.id)/overview?release_stage_name=\(releaseStage)")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let projectOverview = try JSONDecoder().decode(BSGProjectOverview.self, from: data)
            completionHandler(.success(projectOverview))
        } catch {
            completionHandler(.failure(error))
        }
    }.resume()
}

// MARK: - Get Project Stability
public func getProjectStability(token: BSGToken,
                                project: BSGProject,
                                completionHandler: @escaping (Result<BSGProjectStability, Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/projects/\(project.id)/stability_trend")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let projectStability = try JSONDecoder().decode(BSGProjectStability.self, from: data)
            completionHandler(.success(projectStability))
        } catch {
            completionHandler(.failure(error))
        }
    }.resume()
}
