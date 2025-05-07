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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel!.text = topTen[indexPath.row]
                
        return cell
    }

    
}
