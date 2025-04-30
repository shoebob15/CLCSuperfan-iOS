import UIKit



class ViewControllerSchedule: UIViewController, UITableViewDataSource, UITableViewDelegate {



    @IBOutlet weak var tableView: UITableView!



//    let data = [

//        ("Baseball Game @ South", "4/19/2025 at 4:45 PM"),

//        ("Girls Lax Game @ CLC", "4/21/2025 at 4:45 PM"),

//        ("Math Team Event @ CLC", "4/25/2025 at 10:00 AM"),

//        ("Girls Soccor Game @ PR", "5/1/2025 at 4:45 PM")

//    ]

    

    var events = [Event]()



    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .white



        tableView.frame = view.bounds

        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableView.dataSource = self

        tableView.delegate = self

        tableView.register(CustomCell.self, forCellReuseIdentifier: "CellSchedule")



        view.addSubview(tableView)

        

        fetchEvents()

    }

    

    private func fetchEvents() {

        NetworkManager.shared.request(api: EventAPI.all) { (result: Result<[Event], NetworkError>) in

            switch result {

            case .success(let events):

                self.events = events

                debugPrint(events)

                

                DispatchQueue.main.async {

                    // update ui

                }

            case .failure(let error):

                print("failed to fetch events from api: \(error)")

            }

        }

    }



    // MARK: - UITableViewDataSource



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return events.count

    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell

       // let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell

        cell.label1.text = "This didnt crash!!!"

        print(events)

        //cell.label1.text = events[indexPath.row]

        //cell.label2.text = events[indexPath.row]

        return cell

    }



    // Optional: set row height

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 60

    }

}

