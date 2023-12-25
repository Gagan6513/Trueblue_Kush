//
//  EventViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!

    var dateFormater = DateFormatter()
    let refreshControl = UIRefreshControl()
    var arrDates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnFilter.layoutIfNeeded()
        self.btnFilter.layoutSubviews()
        self.btnFilter.layer.cornerRadius = self.btnFilter.layer.frame.width / 2
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "AddEventPopupVC") as! AddEventPopupVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.view.isOpaque = false
        self.present(ctrl, animated: false)
    }
    
    func setupTableView() {
        
        self.arrDates = Date().getMonthDates()
        print(self.arrDates)
        self.btnFilter.isHidden = false // true
        self.tableView.isHidden = false // true
        
        self.dateFormater.dateFormat = "dd-MM-YYYY"

        self.tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 100, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "EventTVC")
                
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
    }

    
    @objc func refresh(_ sender: AnyObject) {
        self.refreshControl.endRefreshing()
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTVC") as? EventTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let datess = DateFormatter()
        datess.dateFormat = "dd"
        cell.lblDate.text = datess.string(from: self.arrDates[indexPath.row])
        
        datess.dateFormat = "MMM"
        cell.lblMonth.text = datess.string(from: self.arrDates[indexPath.row])
        
        return cell
    }
}
