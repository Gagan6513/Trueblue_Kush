//
//  HourlyEventTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit
import Applio

class HourlyEventTVC: UITableViewCell {

    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var tblMain = UITableView()
    var obs: NSKeyValueObservation?
    var btnExpandClick: (() -> Void)?
    var count = 0
    
    var dataa: HourEvents?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowDetails(_ sender: Any) {
        self.btnExpandClick?()
    }
    
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "TodaysEventsTVC")
        
        self.obs = self.tableView.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.tblMain.beginUpdates()
            self.tableViewHeight.constant = height
            self.tblMain.endUpdates()
        }
    }
    
    func setupDetails(data: HourEvents) {
        self.dataa = data
        self.lblHour.text = data.title ?? ""
        self.tableView.reloadData()
    }
}

extension HourlyEventTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataa?.events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysEventsTVC") as? TodaysEventsTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if let data = self.dataa?.events?[indexPath.row] {
            cell.setupDetails(data: data)
        }
        
        return cell
    }
}
