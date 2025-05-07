//
//  Event.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import Foundation

struct Event: Codable {
    let id: UUID
    
    let name: String
    let code: String
    let lat: Double
    let lon: Double
    let startTime: Int
    let stopTime: Int
    
    // returns time of event as MM/DD/YY, HH:MM AM - HH:MM PM
    var timeRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let start = Date(timeIntervalSince1970: TimeInterval(startTime))
        let stop = Date(timeIntervalSince1970: TimeInterval(stopTime))
        
        let startString = formatter.string(from: start)
        formatter.dateStyle = .none
        let stopString = formatter.string(from: stop)
        
        return "\(startString) - \(stopString)"
    }
}
