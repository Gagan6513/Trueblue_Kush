//
//  EventDetailsViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var tableViewHourlyEvents: UITableView!
    @IBOutlet weak var tableViewTodaysEvents: UITableView!
     
    var selectedIndex = -1
    var selectedDate = ""
    var eventDetailsData = EventDetailsData()
   
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
        
        let api_timeFormater = DateFormatter()
        api_timeFormater.dateFormat =  "yyyy-MM-dd"
        let api_time = api_timeFormater.date(from: self.selectedDate)
        api_timeFormater.dateFormat =  "dd-MM-yyyy"
        self.navigationTitle.text = "Event list of " + api_timeFormater.string(from: api_time ?? Date())
        
        self.getEventDetails()
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewHourlyEvents {
            return self.eventDetailsData.hourEvents?.count ?? 0
        } else {
            return self.eventDetailsData.dayEvents?.count ?? 0
        }
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
            
            if let data = self.eventDetailsData.hourEvents?[indexPath.row] {
                cell.setupDetails(data: data)
            }
            
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
            if let data = self.eventDetailsData.dayEvents?[indexPath.row] {
                cell.setupDetails(data: data)
            }
            cell.lblTime.isHidden = true
            return cell
        }
    }
}

extension EventDetailsViewController {
    
    func getEventDetails() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.get_event_details)!
        webService.method = .post
        
        var param = [String: Any]()
        param["userId"] = UserDefaults.standard.userId()
        param["eventDate"] = self.selectedDate        
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(EventDetailsModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? EventDetailsModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.eventDetailsData = data.data ?? EventDetailsData()
                    self.tableViewHourlyEvents.reloadData()
                    self.tableViewTodaysEvents.reloadData()
                    
                    DispatchQueue.main.async {
                        if let count = self.eventDetailsData.hourEvents?.count, count != 0 {
                            self.selectedIndex = 0
                            self.tableViewHourlyEvents.reloadData()
                            self.tableViewHourlyEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }
}
