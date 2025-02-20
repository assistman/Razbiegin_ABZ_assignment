//
//  UsersModel.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 20.02.2025.
//

import Foundation

// api url: https://frontend-test-assignment-api.abz.agency/api/v1

enum GetUsersErrorCode {
  case custom(Int)
  case success, notFound, unprocessableContent

  var value: Int {
    switch self {
    case .success:
      return 200
    case .notFound:
      return 404
    case .unprocessableContent:
      return 422
    case .custom(let customValue):
      return customValue
    }
  }
}

struct UsersResponse: Codable {
    let success: Bool // true
    let page: Int
    let total_pages: Int
    let total_users: Int
    let count: Int
    let links: Links
    let users: [User]
}

struct UsersErrorResponse: Codable {
    let success: Bool // false
    let message: String

}

struct Links: Codable {
    let next_url: String?
    let prev_url: String?
}

/*
 "id": "37",
 "name": "Lisa",
 "email": "lisa.medina@example.com",
 "phone": "+380564753087",
 "position": "Security",
 "position_id": "3",
 "registration_timestamp": 1537639019,
 "photo": "https://frontend-test-assignment-api.abz.agency/images/users/5b977ba20bd9537.jpeg"
 */
struct User: Codable {
    let id: Int
    let email: String
    let phone: String
    let position: String
    let position_id: Int
    let registration_timestamp: String
    let photo: String
}
