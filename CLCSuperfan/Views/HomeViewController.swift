//
//  HomeViewController.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventTable: UITableView!
    
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    var events = [Event]()
    var selectedEvent: Event! = nil
    
    var isAdmin = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventTable.delegate = self
        eventTable.dataSource = self
        AuthManager.setup()
        
        // TODO: save refresh token to keychain
        if !AuthManager.authenticated {
            performSegue(withIdentifier: "authSegue", sender: self)
        } else {
            fetchEvents()
        }
        
    }
    
    override func viewDidLoad() {
        NetworkManager.shared.request(api: UserAPI.user) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let result):
                self.greeting.text = "Welcome back, \(result.firstName)"
                self.pointsLabel.text = "Points: \(result.points)"
            case .failure:
                print("couldn't fetch user data")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTable.dequeueReusableCell(withIdentifier: "eventCell")!
        
        cell.textLabel!.text = events[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "eventDetailSegue", sender: self)
    }
    
    private func fetchEvents() {
        NetworkManager.shared.request(api: EventAPI.all) { (result: Result<[Event], NetworkError>) in
            switch result {
            case .success(let events):
                self.events = events
                debugPrint(events)
                
                DispatchQueue.main.async {
                    self.eventTable.reloadData()
                }
            case .failure(let error):
                print("failed to fetch events from api: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authSegue" {
            let vc = segue.destination as! ViewController
            vc.vc = self
        } else if segue.identifier == "eventDetailSegue" {
            let vc = segue.destination as! EventRedeemViewController
            vc.event = selectedEvent
        }
    }
    
    // refreshes data in view and, if admin, will push to new vc
    func refresh() {
        if isAdmin {
            performSegue(withIdentifier: "adminSegue", sender: self)
        } else {
            fetchEvents()
            
            // TODO: repeated code
            NetworkManager.shared.request(api: UserAPI.user) { (result: Result<User, NetworkError>) in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.greeting.text = "Welcome back, \(result.firstName)"
                        self.pointsLabel.text = "Points: \(result.points)"
                        
                        print(result.role)
                    }
                case .failure:
                    print("couldn't fetch user data")
                }
            }
        }
    }

}
