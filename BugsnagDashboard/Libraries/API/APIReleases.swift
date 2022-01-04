//
//  APIReleases.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 21/12/2021.
//

import Foundation

// MARK: - Get Release Groups
// https://api.bugsnag.com/projects/project_id/release_groups?release_stage_name=production&top_only=true&per_page=30
public func getReleaseGroups(token: BSGToken,
                             project: BSGProject,
                             releaseStage: String,
                             completionHandler: @escaping (Result<[BSGReleaseGroup], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/projects/\(project.id)/release_groups?release_stage_name=\(releaseStage)&per_page=100")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    logMessage(message: "Release Groups: getting release groups of project ID: \(project.id), and releaseStage \(releaseStage)")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let releaseGroups = try JSONDecoder().decode([BSGReleaseGroup].self, from: data)
            completionHandler(.success(releaseGroups))
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

// MARK: - Get releases of a Release Group
public func getReleaseOfReleaseGreoup(token: BSGToken,
                       releaseGroupId: String,
                       completionHandler: @escaping (Result<[BSGRelease], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/release_groups/\(releaseGroupId)/releases?per_page=100")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    logMessage(message: "Releases: getting releases of release group ID: \(releaseGroupId)")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let releases = try JSONDecoder().decode([BSGRelease].self, from: data)
            completionHandler(.success(releases))
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
