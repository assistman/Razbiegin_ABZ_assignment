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
    case emptyToken
}

class NetworkManager {
    private let baseUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/"
    private let usersUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    private let tokenUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/token"
    private let positionsUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/positions"

    var token: String?

    func getTokenString() async throws -> String {
        if let token = self.token {
            return token
        }
        let request = try buildTokenRequest()
        let responseData = try await fetchRemoteData(request: request)
        let tokenResponse = try decodeTokenResponse(responseData)
        self.token = tokenResponse.token
        return self.token ?? ""
    }

    func getPositions() async throws -> PositionsResponse {
        let request = try buildPositionsRequest()
        let responseData = try await fetchRemoteData(request: request)
        let positionsResponse = try decodePositionsResponse(responseData)
        return positionsResponse
    }

    func getUsers(page: Int, count: Int) async throws -> UsersResponse {
        let endpoint = usersUrl + "?page=\(page)&count=\(count)" // TODO: Use URLComponents
        print("endpoint: \(endpoint)")
        guard let url = URL(string: endpoint) else {
            throw NetworkError.badUrl
        }
        let request = buildGetUsersRequest(url: url)
        let responseData = try await fetchRemoteData(request: request)
        return try decodeUsersResponse(responseData)
    }

    func signUpUser(parameters: SignUpUserParameters) async throws -> SignUpResponse {
        let requestParameters: [String: String] = [
            "name": parameters.name,
            "email": parameters.email,
            "phone": parameters.phone,
            "position_id": "\(parameters.positionId)",
        ]
        let request = try buildSignUpUserRequest(
            parameters: requestParameters,
            photo: parameters.photo
        )
        let responseData = try await fetchRemoteData(request: request)
        let response = try JSONDecoder().decode(SignUpResponse.self, from: responseData)
        return response
    }

    private func buildTokenRequest() throws -> URLRequest {
        guard let url = URL(string: self.tokenUrl) else {
            throw NetworkError.badUrl
        }
        return buildGetRequestWith(url: url)
    }

    private func buildPositionsRequest() throws -> URLRequest {
        guard let url = URL(string: self.positionsUrl) else {
            throw NetworkError.badUrl
        }
        return buildGetRequestWith(url: url)
    }

    private func buildGetUsersRequest(url: URL) -> URLRequest {
        return buildGetRequestWith(url: url)
    }

    private func buildGetRequestWith(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func buildSignUpUserRequest(
        parameters: [String: String],
        photo: Data
    ) throws -> URLRequest {
        guard let url = URL(string: self.usersUrl) else {
            throw NetworkError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let token = self.token else {
            // handle token request here
            throw NetworkError.emptyToken
        }
        request.addValue(token, forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = try .withParameters(
            parameters,
            images: [
                .init(
                    name: "photo",
                    fileName: "photo.jpg",
                    data: photo
                )
            ],
            boundary: boundary
        )
//        Just for test purposes
//        print("request.httpBody?.utf8: \(request.httpBody?.utf8)")
        return request
    }

    private func fetchRemoteData(request: URLRequest) async throws -> Data {
        let data = try await sendRequest(request) // TODO: Handle network errors(e.g. expired token) on the network manager layer!
        // Just for test purposes
        let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        print("\njson dict: \n\(jsonDict)\n")
        return data
    }

    private func sendRequest( _ request: URLRequest) async throws -> Data {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }

    private func decodeTokenResponse(_ data: Data) throws -> TokenResponse {
        try JSONDecoder().decode(TokenResponse.self, from: data)
    }

    private func decodeUsersResponse(_ data: Data) throws -> UsersResponse {
        try JSONDecoder().decode(UsersResponse.self, from: data)
    }
//
//    private func decodeSignUpResponse(_ data: Data) throws -> SignUpResponse {
//        try JSONDecoder().decode(SignUpResponse.self, from: data)
//    }

    private func decodePositionsResponse(_ data: Data) throws -> PositionsResponse {
        try JSONDecoder().decode(PositionsResponse.self, from: data)
    }
}
