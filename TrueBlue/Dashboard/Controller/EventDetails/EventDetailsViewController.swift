//
//  EventDetailsViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var tableViewHourlyEvents: UITableView!
    @IBOutlet weak var tableViewTodaysEvents: UITableView!
    
    var selectedIndex = -1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    func setupUI() {
        self.tableViewHourlyEvents.delegate = self
        self.tableViewHourlyEvents.dataSource = self
        self.tableViewHourlyEvents.registerNib(for: "HourlyEventTVC")
        
        self.tableViewTodaysEvents.delegate = self
        self.tableViewTodaysEvents.dataSource = self
        self.tableViewTodaysEvents.registerNib(for: "TodaysEventsTVC")
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewHourlyEvents {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyEventTVC") as? HourlyEventTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            cell.tableView.isHidden = self.selectedIndex != indexPath.row
            cell.lblHour.backgroundColor = (self.selectedIndex == indexPath.row) ? .lightGray.withAlphaComponent(0.5) : .clear
            cell.tblMain = tableView
            cell.count = self.selectedIndex == indexPath.row ? 2 : 0
            cell.tableView.reloadData()
            
            cell.btnExpandClick = { [weak self] in
                guard let self else { return }
                self.selectedIndex = self.selectedIndex == indexPath.row ? -1 : indexPath.row
                self.tableViewHourlyEvents.reloadData()
                self.tableViewHourlyEvents.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysEventsTVC") as? TodaysEventsTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }
}
