//
//  OAuthAPI.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/8/25.
//

import Foundation

enum OAuthAPI: APIProtocol {
    case google(token: String)
    
    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/oauth"
        
        switch self {
        case .google:
            return URL(string: "\(baseURL)/google")!
        }
    }
    
    var method: String {
        switch self {
        case .google:
                return "POST"
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case let .google(token):
            return [
                "token": token
            ]
        }
    }
    
    
}
