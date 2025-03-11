//
//  AuthManager.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import Foundation

// static class for storing state variables
class AuthManager {
    static var authenticated = false
    static var token: String? = nil // jwt of user, is null if user is not authenticated
    
}
