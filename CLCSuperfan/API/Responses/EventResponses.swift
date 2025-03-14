//
//  EventResponses.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/12/25.
//

import Foundation

struct RedeemResponse: Decodable {
    let success: Bool // if the event was successfully redeemed
    let message: String // ui message to display to frontend (prob in alert or smth)
}
