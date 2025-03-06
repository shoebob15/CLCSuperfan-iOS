//
//  AuthResponses.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import Foundation

// responses relating to /auth endpoint

struct LoginResponse: Decodable {
    let token: String
}

struct RegistrationResponse: Decodable {
    let body: String
}
