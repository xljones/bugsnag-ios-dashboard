//
//  APIErrors.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 16/12/2021.
//

import Foundation

public func getErrors(token: BSGToken,
                      project: BSGProject,
                      completionHandler: @escaping (Result<[BSGError], Error>) -> Void) {
    var request = URLRequest(url: URL(string: "https://api.bugsnag.com/projects/\(project.id)/errors")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("token \(token.getToken())", forHTTPHeaderField: "Authorization")
    
    print("Errors: getting error list with project ID: \(project.id)")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return completionHandler(.failure(error!)) }
        do {
            let errors = try JSONDecoder().decode([BSGError].self, from: data)
            completionHandler(.success(errors))
        } catch {
            do {
                // failed to map the returned JSON to the expected type, so inspect the payload
                let returnedJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(returnedJson as Any)
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }.resume()
}
