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

struct SignUpResponse: Codable {
    let success: Bool
    let user_id: Int
    let message: String
}

struct TokenResponse: Codable {
    let token: String
    let success: Bool
}

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}

struct Position: Codable {
    let id: Int
    let name: String
}

struct SignUpUserParameters: Codable {
    let name: String
    let email: String
    let phone: String
    let position_id: Int
    let photo: String
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
