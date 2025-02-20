//
//  NetworkManager.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

func getUsers(completion: @escaping (Result<UsersResponse, Error>) -> Void) {
    let endpoint = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    guard let url = URL(string: endpoint) else {
        return
    }
    fetchRemoteData(url: url, method: HTTPMethod.GET.rawValue, parameters: nil)
}

func createUser(user: SignUpUserParam, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
    let endpoint = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    guard let url = URL(string: endpoint) else {
        return
    }
    let parameters: [String: Any] = [
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "position_id": user.position_id,
        "photo": user.phone // TODO: Check for the value type!
    ]
    fetchRemoteData(url: url, method: HTTPMethod.POST.rawValue, parameters: parameters)
}

private func fetchRemoteData(url: URL, method: String, parameters: [String: Any]?) {
    guard let request = buildRequest(url: url, method: method, parameters: parameters) else {
        return
    }
    URLSession.shared.dataTask(with: request){ data, response, error in
        if let error = error {
            // TODO: Add error handling
            print("Error: \(error)")
            return
        }
        guard let data = data else {
            print("Error: No data")
            return
        }
        do {
            // TODO: How to properly decode data? I have different response types
//            let decodedData = try JSONDecoder().decode(T.self, from: data)
        } catch let jsonError {
            print("Failed to decode json", jsonError)
        }
    }.resume()
}

func buildRequest(url: URL, method: String, parameters: [String: Any]?) -> URLRequest? {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let parameters = parameters {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            return nil
        }
        request.httpBody = jsonData
    }
    return request
}
