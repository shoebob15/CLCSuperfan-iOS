//
//  LeaderboardViewController.swift
//  CLCSuperfan
//
//  Created by LOGAN GOUGH on 4/16/25.
//

import UIKit

class LeaderboardViewController: UIViewController{
    var topTen = [User]()
    var username = ""
    var point = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.request(api: UserAPI.leaderboard) { (result: Result<[User], NetworkError>) in
            switch result {
            case .success(let users):
                self.topTen = users
            case .failure:
                print("couldn't fetch user data")
            }
        }
        
        
    }

    
}
