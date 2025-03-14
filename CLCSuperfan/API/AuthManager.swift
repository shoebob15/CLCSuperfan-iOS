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
    static var refresh: String? = nil
    
    
    // load jwt and refresh jwt from keychain
    static func setup() {
        let keychain = KeychainSwift()
        
        if let token = keychain.get("user_jwt") {
            self.token = token
            authenticated = true
        }
        
        if let refresh = keychain.get("refresh_jwt") {
            self.refresh = refresh
        }
    }
    
    // save current tokens in the AuthManager to the keychain
    static func save() {
        
    }
    
}
