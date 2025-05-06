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
}
