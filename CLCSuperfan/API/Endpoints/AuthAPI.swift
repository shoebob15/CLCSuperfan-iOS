//
//  AuthAPI.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import Foundation

// auth, not to be confused w/ oauth
// defines request structures
enum AuthAPI: APIProtocol {
    // register endpoint
    case register(firstName: String, lastName: String, email: String, password: String)
    // login endpoint
    case login(email: String, password: String)
    
    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/auth"
        
        switch self {
        case .register:
            return URL(string: "\(baseURL)/register")!
        case .login:
            return URL(string: "\(baseURL)/login")!
        }
    }
    
    var method: String {
        switch self {
        case .register, .login:
            return "POST"
        }
    }
    
    // returns nil if request doesn't have a body (ex: GET)
    var body: [String: Any]? {
        switch self {
        case let .register(firstName, lastName, email, password):
            return [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "password": password
            ]
        case let .login(email, password):
            return [
                "email": email,
                "password": password
            ]
        }
    }
}
