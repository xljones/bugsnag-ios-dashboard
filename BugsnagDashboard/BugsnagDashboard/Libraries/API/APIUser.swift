//
//  APIUser.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 15/12/2021.
//

import Foundation

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
