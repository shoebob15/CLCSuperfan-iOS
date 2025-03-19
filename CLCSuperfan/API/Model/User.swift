//
//  User.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/18/25.
//

import Foundation

struct User: Decodable {
    let id: UUID
    let firstName, lastName: String
    let email: String
    let password: String? // nullable, hashed if exists
    let role: String // "USER" or "ADMIN"
    let authProvider: String // "APPLE", "GOOGLE", or "LOCAL"
    let oauthIdentity: String? // nullable
    let points: String
}
