//
//  UserAPI.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/18/25.
//

import Foundation

enum UserAPI: APIProtocol {
    case user // get current user
    
    // ADMIN ENDPOINTS
    case users
    case getUser(id: String)
    case createUser(user: User)
    case updateUser(id: String, user: User)
    case deleteUser(id: String)
    
    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/user"
        
        switch self {
        case .user:
            return URL(string: "\(baseURL)/user")!
            
        case .users:
            return URL(string: "\(baseURL)/users")!
            
        case .getUser(let id):
            return URL(string: "\(baseURL)/users/\(id)")!
            
        case .createUser:
            return URL(string: "\(baseURL)/users")!
            
        case .updateUser(let id, _):
            return URL(string: "\(baseURL)/users/\(id)")!
            
        case .deleteUser(let id):
            return URL(string: "\(baseURL)/users/\(id)")!
        }
    }
    
    var method: String {
        switch self {
        case .user, .users, .getUser:
            return "GET"
            
        case .createUser:
            return "POST"
            
        case .updateUser:
            return "PUT"
            
        case .deleteUser:
            return "DELETE"
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .user, .users, .getUser, .deleteUser:
            return nil
            
        case .createUser(let user), .updateUser(_, let user):
            return user.dictionary

        }
        
    }
    
    

    
    
}
