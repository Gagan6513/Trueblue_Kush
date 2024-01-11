//
//  EventViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!

    var dateFormater = DateFormatter()
    let refreshControl = UIRefreshControl()
    var selectedDate = Date()
    var arrDates = [Date]()
    var arrEvents = [EventList]()
    
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
    
    @IBAction func btnCalender(_ sender: Any) {
//        var storyboardName = String()
//        var vcId = String()
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            storyboardName = AppStoryboards.DASHBOARD
//            vcId = AppStoryboardId.SELECT_DATE
//        } else {
//            storyboardName = AppStoryboards.DASHBOARD_PHONE
//            vcId = AppStoryboardId.SELECT_DATE_PHONE
//        }
//        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
//        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
//        ctrl.modalPresentationStyle = .overFullScreen
////        ctrl.datePicker.datePickerMode
//        ctrl.selectedDatee = { [weak self] date in
//            guard let self else { return }
//            self.selectedDate = date
//            self.setupDates()
//        }
//        self.present(ctrl, animated: false)
        
        
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "MonthSelectionVC") as! MonthSelectionVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.selectedDate = date
            self.setupDates()
        }
        self.present(ctrl, animated: false)

        
    }
    
    func setupTableView() {
        
        self.setupDates()
        
        self.dateFormater.dateFormat = "yyyy-MM-dd"

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "NewEventTVC")
                
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
        NotificationCenter.default.addObserver(forName: .eventListRefresh, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.getEventList(isProgressShow: false)
        })
    }

    func setupDates() {
        
        let datess = DateFormatter()
        datess.dateFormat = "MMMM YYYY"
        
        self.navigationTitle.text = datess.string(from: self.selectedDate)
        
        datess.dateFormat = "MMM"
        self.monthLabel.text = datess.string(from: self.selectedDate)
        
        self.arrDates = self.selectedDate.getMonthDates()

        self.tableView.reloadData()
        self.getEventList()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getEventList(isProgressShow: false)
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewEventTVC") as? NewEventTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let mainDate = self.dateFormater.string(from: self.arrDates[indexPath.row])
        
        cell.setupData(data: self.arrEvents.first(where: { $0.EVENT_DATE == mainDate }) ?? EventList())
//        else {
//            cell.viewTotalEvent.isHidden = true
//            cell.viewPendingEvent.isHidden = true
//        }
        
        let datess = DateFormatter()
        datess.dateFormat = "EEE-dd"
        cell.lblDate.text = datess.string(from: self.arrDates[indexPath.row])
        
//        datess.dateFormat = "MMM"
//        cell.lblMonth.text = datess.string(from: self.arrDates[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainDate = self.dateFormater.string(from: self.arrDates[indexPath.row])
        if let data = self.arrEvents.first(where: { $0.EVENT_DATE == mainDate }) {
            let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            ctrl.selectedDate = mainDate
            ctrl.modalPresentationStyle = .overFullScreen
            ctrl.view.isOpaque = false
            self.present(ctrl, animated: false)
        } else {
            showAlert(title: alert_title, messsage: "Sorry! You Don't have any Pending Events for this date")
        }
    }
}

extension EventViewController {
    
    func getEventList(isProgressShow: Bool = true) {
        
        if isProgressShow {
            CommonObject().showProgress()
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.get_eventlist)!
        webService.method = .post
        
        let datess = DateFormatter()
        var param = [String: Any]()
        param["assignedTo"] = UserDefaults.standard.userId()
        datess.dateFormat = "MM"
        param["eventMonth"] = datess.string(from: self.arrDates.first ?? Date())
        datess.dateFormat = "YYYY"
        param["eventYear"] = datess.string(from: self.arrDates.first ?? Date())
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            self.refreshControl.endRefreshing()
            self.tableView.isHidden = false

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(EventDataModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? EventDataModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.tableView.isHidden = false
                    self.arrEvents = data.data ?? []
                    self.tableView.reloadData()
                }
            }
        }
    }
}
