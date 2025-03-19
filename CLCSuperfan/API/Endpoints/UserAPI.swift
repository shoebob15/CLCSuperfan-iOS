//
//  UserAPI.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/18/25.
//

import Foundation

enum UserAPI: APIProtocol {
    case user // get current user
    
    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/user"
        
        switch self {
        case .user:
            return URL(string: "\(baseURL)/user")!
        }
    }
    
    var method: String {
        switch self {
        case .user:
            return "GET"
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .user:
            return nil
        }
    }
    
    

    
    
}
