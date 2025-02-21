//
//  NetworkManager.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation

// api url: https://frontend-test-assignment-api.abz.agency/api/v1

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkError: Error {
    case badUrl
}

class NetworkManager {
    private let baseUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/"
    private let usersUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    private let tokenUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/token"
    var token: String?

    func getToken() async throws -> TokenResponse {
        let endpoint = tokenUrl
        guard let url = URL(string: endpoint) else {
            throw NetworkError.badUrl
        }
        let responseData = try await fetchRemoteData(url: url, method: HTTPMethod.GET.rawValue, parameters: nil)
        let tokenResponse = try decodeTokenResponse(responseData)
        self.token = tokenResponse.token
        return tokenResponse
    }

    func getUsers(page: Int, count: Int) async throws -> UsersResponse {
        let endpoint = usersUrl + "?page=\(page)&count=\(count)" // TODO: Use URLComponents
        guard let url = URL(string: endpoint) else {
            throw NetworkError.badUrl
        }
        let responseData = try await fetchRemoteData(url: url, method: HTTPMethod.GET.rawValue, parameters: nil)
        return try decodeUsersResponse(responseData)
    }

    func createUser(user: SignUpUserParam) async throws -> Void {
        let endpoint = usersUrl
        guard let url = URL(string: endpoint) else {
            throw NetworkError.badUrl
        }
        let parameters: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            "position_id": user.position_id,
            "photo": user.phone // TODO: Check for the value type!
        ]
        let responseData = try await fetchRemoteData(url: url, method: HTTPMethod.POST.rawValue, parameters: parameters)
    }

    private func sendRequest( _ request: URLRequest) async throws -> Data {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }

    private func fetchRemoteData(url: URL, method: String, parameters: [String: Any]?) async throws -> Data {
        let request = try buildRequest(url: url, method: method, parameters: parameters)
        let data = try await sendRequest(request) // TODO: Handle network errors(e.g. expired token) on the network manager layer!
        // Just for test purposes
        let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        print("\njson dict: \n\(jsonDict)\n")
        return data
    }

    private func decodeTokenResponse(_ data: Data) throws -> TokenResponse {
        try JSONDecoder().decode(TokenResponse.self, from: data)
    }

    private func decodeUsersResponse(_ data: Data) throws -> UsersResponse {
        try JSONDecoder().decode(UsersResponse.self, from: data)
    }

    private func decodeSignUpResponse(_ data: Data) throws -> SignUpResponse {
        try JSONDecoder().decode(SignUpResponse.self, from: data)
    }

    // TODO: Decompose this since create user has another request
    private func buildRequest(url: URL, method: String, parameters: [String: Any]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        return request
    }

}
