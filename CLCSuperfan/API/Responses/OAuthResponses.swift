//
//  OAuthResponses.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/8/25.
//

import Foundation

struct GoogleOAuthResponse: Decodable {
    let success: Bool
    let message: String
    let token: String // jwt token, is null if success = false
}
