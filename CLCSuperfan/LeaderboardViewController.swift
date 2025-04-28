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
                self.tableView.reloadData()
            case .failure:
                print("couldn't fetch user data")
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! LeaderboardCell2
        var tempLast = topTen[indexPath.row].lastName
        if let firstLetter = tempLast.first {
            let firstLetterString = String(firstLetter)
            print(firstLetterString)
            tempLast = "\(firstLetterString)"
        }
        var blat = "\(topTen[indexPath.row].firstName)  \(tempLast)"
        var blah = "\(topTen[indexPath.row].points)"
        cell.lab1?.text = "\(blat)"
        cell.lab2?.text = "\(blah)"
        
        return cell
    }

    
}
