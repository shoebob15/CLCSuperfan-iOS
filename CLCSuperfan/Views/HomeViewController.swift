//
//  HomeViewController.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import UIKit
import AVFoundation

class AppData {
    // jank
    private static var inited = false
    
    static var mostRecentScan: Date?
    
    static let emailAlert = UIAlertController(title: "Email Error", message: "Please enter a valid email", preferredStyle: .alert)
    static let passwordAlert = UIAlertController(title: "Password Error", message: "Password must contain 8+ characters, 1 uppercase, and 1 special character", preferredStyle: .alert)
    static let firstNameAlert = UIAlertController(title: "First Name Error", message: "Please enter a first name", preferredStyle: .alert)
    static let lastNameAlert = UIAlertController(title: "Last Name Error", message: "Please enter a last name", preferredStyle: .alert)
    
    static var userEmail: String?
    static var userPassword: String?
    static let emailExistsAlert = UIAlertController(title: "Email Already Exists", message: "Please sign up with a different email or sign in", preferredStyle: .alert)
    
    init() {
        if !AppData.inited {
            AppData.emailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppData.passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppData.firstNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppData.lastNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppData.emailExistsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        AppData.inited = true
    }
}



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventTable: UITableView!
    
    
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    var events = [Event]()
    var selectedEvent: Event! = nil
    @IBOutlet weak var signOutButton: UIButton!
    
    var signOutTimer = Timer()
    var canSignOut = false

    
    var isAdmin = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventTable.delegate = self
        eventTable.dataSource = self
        AuthManager.setup()
        
        configureRefreshControl()
        
        if !AuthManager.authenticated {
            performSegue(withIdentifier: "authSegue", sender: self)
        } else {
            fetchEvents()
            getUser()
        }
        
    }
    
    override func viewDidLoad() {
        getUser()
        
        signOutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkSignOut), userInfo: nil, repeats: true)
        

        

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTable.dequeueReusableCell(withIdentifier: "eventCell")!
        
        cell.textLabel!.text = events[indexPath.row].name
        cell.detailTextLabel!.text = events[indexPath.row].timeRange
        
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
                
              //  self.sortEventsAlphabetically()
                
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
    // triggered also by pull to refresh on event table
    @objc func refresh() {
        if isAdmin {
            performSegue(withIdentifier: "adminSegue", sender: self)
        } else if AuthManager.token == nil {
            performSegue(withIdentifier: "authSegue", sender: self)
        } else {
            fetchEvents()
            getUser()
        }
    }
    
    @objc func checkSignOut() {
        canSignOut = CooldownManager.canRedeem
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
                
        if !canSignOut {
            signOutButton.titleLabel!.text = " \(CooldownManager.timeLeft.secondsToHMS())"
            signOutButton.imageView!.image = UIImage(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
            signOutButton.isEnabled = false
        } else {
            signOutButton.titleLabel!.text = " Sign Out"
            signOutButton.imageView!.image = UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")
            signOutButton.isEnabled = true
        }
    }
    
    func configureRefreshControl() {
        eventTable.refreshControl = UIRefreshControl()
        eventTable.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func getUser(){
        NetworkManager.shared.request(api: UserAPI.user) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.greeting.text = "Welcome back, \(result.firstName)"
                    self.pointsLabel.text = "Points: \(result.points)"
                    self.eventTable.refreshControl?.endRefreshing()
                    
                }
            case .failure:
                print("couldn't fetch user data")
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        AuthManager.signOut()
        isAdmin = false
        refresh()
    }
    
    private func sortEventsAlphabetically() {
        events.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
       // eventTable.reloadData()
    }
    
}
