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

enum NetworkError: Error {
    case badUrl
}

class NetworkManager {

    private let baseUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/users"

    func getUsers(page: Int, count: Int) async throws -> UsersResponse {
        let endpoint = baseUrl + "?page=\(page)&count=\(count)" // TODO: Use URLComponents
        guard let url = URL(string: endpoint) else {
            throw NetworkError.badUrl
        }
        return try await fetchRemoteData(url: url, method: HTTPMethod.GET.rawValue, parameters: nil)
    }

//    func createUser(user: SignUpUserParam, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
//        let endpoint = baseUrl
//        guard let url = URL(string: endpoint) else {
//            return
//        }
//        let parameters: [String: Any] = [
//            "name": user.name,
//            "email": user.email,
//            "phone": user.phone,
//            "position_id": user.position_id,
//            "photo": user.phone // TODO: Check for the value type!
//        ]
//        fetchRemoteData(url: url, method: HTTPMethod.POST.rawValue, parameters: parameters)
//    }

    func sendRequest( _ request: URLRequest) async throws -> Data {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }

    private func fetchRemoteData(url: URL, method: String, parameters: [String: Any]?) async throws -> UsersResponse {
        let request = try buildRequest(url: url, method: method, parameters: parameters)
        let data = try await sendRequest(request) // TODO: Handle network errors(e.g. expired token) on the network manager layer!
        if let jsonString = String(data: data, encoding: .utf8) {
            print("json string: \(jsonString)")
        }
        let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        print("\n\njson dict: \n\(jsonDict)\n")

        return try decodeUsersResponse(data)
    }

    private func decodeUsersResponse(_ data: Data) throws -> UsersResponse {
        try JSONDecoder().decode(UsersResponse.self, from: data)
    }

    func buildRequest(url: URL, method: String, parameters: [String: Any]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        return request
    }

}
