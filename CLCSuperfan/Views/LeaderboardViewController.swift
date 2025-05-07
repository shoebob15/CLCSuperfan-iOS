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
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! LeaderboardCell2
        var place = indexPath.row + 1
        cell.lab1.text = "      \(place). \(topTen[indexPath.row])"
        
        if indexPath.row == 0{
            
            cell.imageView?.image = UIImage(named: "1")
            
        }
        else if indexPath.row == 1{
            
            cell.imageView?.image = UIImage(named: "second")
            
        }
        else if indexPath.row == 2{
            
            cell.imageView?.image = UIImage(named: "third")
            
        }
                
        return cell
    }

    
}
