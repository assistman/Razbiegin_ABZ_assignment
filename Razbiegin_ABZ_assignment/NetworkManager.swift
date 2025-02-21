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

class NetworkManager {
    
    static let shared = NetworkManager()

    private let baseUrl = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    func getUsers(completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let endpoint = baseUrl
        guard let url = URL(string: endpoint) else {
            return
        }
        fetchRemoteData(url: url, method: HTTPMethod.GET.rawValue, parameters: nil)
    }

    func createUser(user: SignUpUserParam, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let endpoint = baseUrl
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

    func sendRequest( _ request: URLRequest) async throws -> Data {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }

    private func fetchRemoteData(url: URL, method: String, parameters: [String: Any]?) {
        guard let request = buildRequest(url: url, method: method, parameters: parameters) else {
            return
        }
        Task {
            do {
                let data = try await sendRequest(request)

                return decodeUsersResponse(data)
            } catch {
                print("Error from server: \(error.localizedDescription)")
                return []
            }
        }
    }

    private func decodeUsersResponse(_ data: Data) -> [User] {
        do {
            if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
            }
            let usersResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
            return usersResponse.users
        } catch {
            print("Failed to decode response: \(error.localizedDescription)")
            let errorResponse = try? JSONDecoder().decode(UsersErrorResponse.self, from: data)
            let errorDesc = errorResponse?.message ?? ""
            print(errorDesc)
            return []
        }
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

}
