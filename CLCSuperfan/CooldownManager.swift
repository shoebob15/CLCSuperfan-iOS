//
//  CooldownManager.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 5/12/25.
//
// manages if a user can redeem an event or log out
import Foundation

// TODO: save lastRedeem in userdefaults
class CooldownManager {
    static var lastRedeem: Int? // unix-date of when a user last redeemed an event
    
    private init() {
        // private init for static class
    }
    
    static var canRedeem: Bool {
        if let time = lastRedeem {
            if Int(Date.now.timeIntervalSince1970) - time > 120 {
                return true
            }
        } else {
            return true
        }
        
        return false
    }
    
    
    static var timeLeft: Int {
        if let time = lastRedeem {
            return 120 - (Int(Date.now.timeIntervalSince1970) - time)
        }
        
        return -1
    }
    
    // duplicate
    static var canSignOut: Bool {
        return canRedeem
    }
    
    static func userRedeemed() {
        lastRedeem = Int(Date.now.timeIntervalSince1970)
    }
}

extension Int {
    // doesn't actually return hours
    func secondsToHMS() -> String {
        let data = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        
        return "\(data.1)m \(data.2)s"

    }
}
