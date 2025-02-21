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

/*
 {
   "success": true,
   "user_id": 25794,
   "message": "New user successfully registered"
 }
 */
struct SignUpResponse: Codable {
    let success: Bool
    let user_id: Int
    let message: String
}

struct TokenResponse: Codable {
    let token: String
    let success: Bool
}

struct SignUpUserParam: Codable {
    let name: String
    let email: String
    let phone: String
    let position_id: Int
    let photo: String
}
