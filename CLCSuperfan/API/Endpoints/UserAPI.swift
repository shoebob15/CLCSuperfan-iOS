//
//  UserAPI.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/18/25.
//

import Foundation

enum UserAPI: APIProtocol {
    case user // get current user
    case leaderboard // get top ten leaderboard
    
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
            
        case .leaderboard:
            return URL(string: "\(baseURL)/leaderboard")!
            
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
        case .user, .users, .getUser, .leaderboard:
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
        case .user, .users, .getUser, .deleteUser, .leaderboard:
            return nil
            
        case .createUser(let user), .updateUser(_, let user):
            return user.dictionary

        }
        
    }
    
    

    
    
}
