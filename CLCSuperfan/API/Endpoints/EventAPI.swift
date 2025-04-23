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
    
    // ADMIN ENDPOINTS
    case getEvent(id: String)
    case createEvent(event: Event)
    case updateEvent(id: String, event: Event)
    case deleteEvent(id: String)
    
    case all

    var url: URL {
        let baseURL = "\(NetworkManager.apiUrl)/event"
        
        switch self {
        case .redeem:
            return URL(string: "\(baseURL)/redeem")!
            
        case .all:
            return URL(string: "\(baseURL)/events")!
            
        case .getEvent(let id):
            return URL(string: "\(baseURL)/event/\(id)")!
            
        case .createEvent:
            return URL(string: "\(baseURL)/events")!
            
        case .updateEvent(let id, _):
            return URL(string: "\(baseURL)/events/\(id)")!
            
        case .deleteEvent(let id):
            return URL(string: "\(baseURL)/events/\(id)")!
        }
    }
    
    var method: String {
        switch self {
        case .redeem, .createEvent:
            return "POST"
        case .all, .getEvent:
            return "GET"
        case .updateEvent:
            return "PUT"
        case .deleteEvent:
            return "DELETE"
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
            
        case .createEvent(let event), .updateEvent(_, let event):
            return event.dictionary
            
        case .all, .getEvent, .deleteEvent:
            return nil
        }
    }
    
    
}
