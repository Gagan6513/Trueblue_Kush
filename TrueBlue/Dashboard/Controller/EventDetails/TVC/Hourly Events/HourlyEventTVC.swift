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
    var btnExpandClick: ((String) -> Void)?
    var needToUpdate = false
    
    var dataa: HourEvents?
    var editButtonClicked: ((Events) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowDetails(_ sender: Any) {
//        self.btnExpandClick?("")
    }
    
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "TodaysEventsTVC")
        
        self.obs = self.tableView.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.needToUpdate ? self.tblMain.beginUpdates() : nil
            self.tableViewHeight.constant = height
            self.needToUpdate ? self.tblMain.endUpdates() : nil
            self.needToUpdate = false
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
        
        cell.editButtonClicked = { [weak self] data in
            guard let self else { return }
            self.editButtonClicked?(data)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.needToUpdate = true
//        guard let cell = tableView.cellForRow(at: indexPath) as? TodaysEventsTVC else { return }
//        cell.lblDescription.numberOfLines = cell.lblDescription.numberOfLines == 1 ? 0 : 1
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TodaysEventsTVC else { return }
        if cell.lblDescription.numberOfTextLines() > 1 {
            if let data = self.dataa?.events?[indexPath.row] {
                self.btnExpandClick?(data.EVENT_DESC ?? "")
            }
        }
    }
}
