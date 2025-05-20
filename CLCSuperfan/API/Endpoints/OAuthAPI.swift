//
//  OAuthAPI.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/8/25.
//

import Foundation

enum OAuthAPI: APIProtocol {
    case google(token: String)
    case apple(code: String)
    
    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/oauth"
        
        switch self {
        case .google:
            return URL(string: "\(baseURL)/google")!
            
        case .apple:
            return URL(string: "\(baseURL)/apple")!
        }
    }
    
    var method: String {
        switch self {
        case .google, .apple:
                return "POST"
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case let .google(token):
            return [
                "token": token
            ]
            
        case let .apple(code):
            return [
                "code": code
            ]
        }
    }
    
    
}
