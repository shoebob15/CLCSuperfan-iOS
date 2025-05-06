//
//  LeaderboardViewController.swift
//  CLCSuperfan
//
//  Created by LOGAN GOUGH on 4/16/25.
//

import UIKit


class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    var topTen = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leaderboard"
        
        
        
        NetworkManager.shared.request(api: UserAPI.leaderboard) { (result: Result<[String], NetworkError>) in
            switch result {
            case .success(let users):
                DispatchQueue.main.async{
                    self.topTen = users
                    self.tableView.reloadData()
                }
            case .failure:
                print("couldn't fetch user data")
            }
        }
        debugPrint(topTen)
        
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
        let blah = "\(topTen[indexPath.row].points)"
        cell.lab1?.text = "\(blat)"
        cell.lab2?.text = "\(blah)"
        cell.Lab3?.text = "\(indexPath.row + 1)."
        
        return cell
    }

    
}
