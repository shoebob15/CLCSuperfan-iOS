//
//  EventAPI.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import Foundation

enum EventAPI: APIProtocol {
    // code: secret code of event to redeem
    // id: id of the event to redeem
    // lat & lon: coordinate for the event's geofence
    // returns 401 if couldn't redeem
    case redeem(code: String, id: String, lat: Double, lon: Double)
    
    case all

    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/event"
        
        switch self {
        case .redeem:
            return URL(string: "\(baseURL)/redeem")!
            
        case .all:
            return URL(string: "\(baseURL)/events")!
        }
    }
    
    var method: String {
        switch self {
        case .redeem:
            return "POST"
        case .all:
            return "GET"
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case let .redeem(code, id, lat, lon):
            return [
                "code": code,
                "id": id,
                "lat": lat,
                "lon": lon
            ]
        case .all:
            return nil
        }
    }
    
    
}
