//
//  APIProtocol.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import Foundation

protocol APIProtocol {
    var url: URL { get }
    
    var method: String { get }
    
    var body: [String: Any]? { get } 
}
