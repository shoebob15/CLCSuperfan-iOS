//
//  AuthManager.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import KeychainSwift
import Foundation

// static class for storing state variables
class AuthManager {
    static var authenticated = false
    static var token: String? = nil // jwt of user, is null if user is not authenticated
    static var username: String? = nil // username of user
    static var password: String? = nil
    static var refresh: String? = nil // refresh token to keep user logged in, expires after ? months
    
    static let keychain = KeychainSwift()

    // load jwt and refresh jwt from keychain
    static func setup() {
        if let token = keychain.get("user_jwt") {
            self.token = token
        }
        
        if let username = keychain.get("username") {
            self.username = username
        }
        
        if let password = keychain.get("password") {
            self.password = password
        }
    }
    
    // save current tokens in the AuthManager to the keychain
    static func save() {
        
    }
    
    // clear out saved keychain values
    static func signOut() {
        keychain.clear()
        token = nil
    }
    
}
