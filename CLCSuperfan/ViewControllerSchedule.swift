import UIKit

class ViewControllerSchedule: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()

    let data = [
        ("Baseball Game @ South", "4/19/2025 at 4:45 PM"),
        ("Girls Lax Game @ CLC", "4/21/2025 at 4:45 PM"),
        ("Math Team Event @ CLC", "4/25/2025 at 10:00 AM"),
        ("Girls Soccor Game @ PR", "5/1/2025 at 4:45 PM")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // got this from chatgpt
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CellSchedule")

        view.addSubview(tableView)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.label1.text = data[indexPath.row].0
        cell.label2.text = data[indexPath.row].1
        return cell
    }

    // Optional: set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
