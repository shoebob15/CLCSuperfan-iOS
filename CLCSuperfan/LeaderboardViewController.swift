//
//  LeaderboardViewController.swift
//  CLCSuperfan
//
//  Created by LOGAN GOUGH on 4/16/25.
//

import UIKit


class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    var topTen = [User]()
    var username = ""
    var point = ""
    var lastInitial = ""
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! LeaderboardCell2
        var i = lastInitial.index(lastInitial.startIndex, offsetBy: 1)
        var blat = "\(topTen[indexPath.row].firstName)  \(i)"
        var blah = "\(topTen[indexPath.row].points) \(i)"
        cell.lab1?.text = "\(blat)"
        cell.lab2?.text = "\(blah)"
        
        return cell
    }

    
}
