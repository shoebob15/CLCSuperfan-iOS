//
//  LeaderboardViewController.swift
//  CLCSuperfan
//
//  Created by LOGAN GOUGH on 4/16/25.
//

import UIKit

class LeaderboardViewController: UIViewController{
    
    
    
    var topTen = [String]()
    var username = ""
    var point = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<10{
            NetworkManager.shared.request(api: UserAPI.user) { (result: Result<User, NetworkError>) in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.username = "\(result.firstName)"
                        self.point =  "\(result.points)"
                        
                        print(result.role)
                    }
                case .failure:
                    print("couldn't fetch user data")
                }
            }
            topTen.append(username)
            print(topTen[i])
        }

    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }

}
