//
//  SignUpModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation

enum SignUpUserErrorCode {
    case custom(Int)
    case success, unauthorized, conflict, unprocessableContent

    var value: Int {
        switch self {
        case .success:
            return 201
        case .unauthorized:
            return 401
        case .conflict:
            return 409
        case .unprocessableContent:
            return 422
        case .custom(let customValue):
            return customValue
        }
    }
}

enum SignUpResponse: Decodable {

    typealias FieldFails = [String: [String]]

    private enum CodingKeys: String, CodingKey {
        case success
        case message
        case user_id
        case fails
    }

    case success(userId: Int)
    case failure(reason: String)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isSuccess = try container.decode(Bool.self, forKey: .success)
        if isSuccess {
            let userId = try container.decode(Int.self, forKey: .user_id)
            self = .success(userId: userId)
        } else {
            let message = try container.decode(String.self, forKey: .message)
            let fails = try container.decode(FieldFails.self, forKey: .fails)
            let reason = fails.values.first?.first ?? message
            self = .failure(reason: reason)
        }
    }
}

struct TokenResponse: Codable {
    let token: String
    let success: Bool
}

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}

struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

struct SignUpUserParameters {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: Data
}

struct PhoneFormatter {

    static func formatPhone(number: String) -> String {
        if number.count != 13 {
            return "Invalid phone number format"
        }
        let formatted = "\(number[0...2]) (\(number[3...5])) \(number[6...8]) - \(number[9...10]) - \(number[11...12])"
        return formatted
    }
}
