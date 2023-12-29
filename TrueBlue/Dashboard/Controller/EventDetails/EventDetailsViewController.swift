//
//  EventDetailsViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventDetailsNavigation: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
}

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var tableViewHourlyEvents: UITableView!
    @IBOutlet weak var tableViewTodaysEvents: UITableView!
     
    var selectedIndex = -1
    var selectedDate = ""
    var eventDetailsData = EventDetailsData()
    var filterEventData = EventDetailsData()
    var arrNavigation = [["title": "All", "icon": "", "type": "all"],
                         ["title": "Collections", "icon": "Collections", "type": "collection_notes"],
                         ["title": "Deliveries", "icon": "Deliveries", "type": "delivery_notes"],
                         ["title": "Tasks", "icon": "Tasks", "type": "todo_task"]]
    var selectedFilter = "all"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnCalender(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_DATE
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_DATE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDatee = { [weak self] date in
            guard let self else { return }
            let datess = DateFormatter()
            datess.dateFormat = "yyyy-MM-dd"
            self.selectedDate = datess.string(from: date)
            
            self.setupNavigationTitle()
            self.getEventDetails()
        }
        self.present(ctrl, animated: false)
    }
    
    func setupNavigationTitle() {
        let api_timeFormater = DateFormatter()
        api_timeFormater.dateFormat =  "yyyy-MM-dd"
        let api_time = api_timeFormater.date(from: self.selectedDate)
        api_timeFormater.dateFormat =  "dd-MM-yyyy"
        self.navigationTitle.text = "Event list of " + api_timeFormater.string(from: api_time ?? Date())
        
    }
    
    func setupUI() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableViewHourlyEvents.isHidden = true
        self.tableViewTodaysEvents.isHidden = true
        
        self.tableViewHourlyEvents.delegate = self
        self.tableViewHourlyEvents.dataSource = self
        self.tableViewHourlyEvents.registerNib(for: "HourlyEventTVC")
        
        self.tableViewTodaysEvents.delegate = self
        self.tableViewTodaysEvents.dataSource = self
        self.tableViewTodaysEvents.registerNib(for: "TodaysEventsTVC")
        
        self.setupNavigationTitle()
        self.getEventDetails()
    }
}

extension EventDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrNavigation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsNavigation", for: indexPath) as? EventDetailsNavigation else { return UICollectionViewCell() }
        
        cell.lblTitle.text = self.arrNavigation[indexPath.row]["title"]
        cell.imgIcon.isHidden = (self.arrNavigation[indexPath.row]["icon"] ?? "") == ""
        if (self.arrNavigation[indexPath.row]["icon"] ?? "") != "" {
            cell.imgIcon.image = UIImage(named: self.arrNavigation[indexPath.row]["icon"] ?? "")
        }
        
        if selectedFilter == (self.arrNavigation[indexPath.row]["type"] ?? "") {
            cell.imgIcon.tintColor = .white
            cell.lblTitle.textColor = .white
            cell.bgView.backgroundColor = .darkGray
        } else {
            cell.imgIcon.tintColor = .black
            cell.lblTitle.textColor = .black
            cell.bgView.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 4), height: collectionView.frame.height)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFilter = (self.arrNavigation[indexPath.row]["type"] ?? "")
        self.collectionView.reloadData()
        self.filterData()
    }
    
    func filterData() {
        if self.selectedFilter == "all" {
            self.filterEventData = self.eventDetailsData
        } else {
            var dayEvents = [Events]()
            var eventss = [Events]()
            var hourEvents = [HourEvents]()
            
            self.eventDetailsData.dayEvents?.forEach({ data in
                if (data.EVENT_TYPE ?? "") == self.selectedFilter {
                    dayEvents.append(data)
                }
            })
            
            self.eventDetailsData.hourEvents?.forEach({ data in
                eventss = []
                print(data.events?.count ?? 0)
                data.events?.forEach({ dataa in
                    if (dataa.EVENT_TYPE ?? "") == self.selectedFilter {
                        eventss.append(dataa)
                    }
                })
                let newEvent = HourEvents()
                newEvent.title = data.title
                newEvent.events = eventss
                hourEvents.append(newEvent)
            })
            
            let newEvent = EventDetailsData()
            newEvent.dayEvents = dayEvents
            newEvent.hourEvents = hourEvents
            self.filterEventData = newEvent
        }
        
        self.tableViewHourlyEvents.reloadData()
        self.tableViewTodaysEvents.reloadData()
        
        if let count = self.filterEventData.hourEvents?.count, count != 0 {
            self.selectedIndex = -1
            self.tableViewHourlyEvents.reloadData()
            self.tableViewHourlyEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewHourlyEvents {
            if let count = self.filterEventData.hourEvents?.count, count != 0 {
                tableView.removeBackgroundView()
                return count
            }
            tableView.setBackgroundView(msg: .hourly_event_empty)
            return 0
        } else {
            if let count = self.filterEventData.dayEvents?.count, count != 0 {
                tableView.removeBackgroundView()
                return count
            }
            tableView.setBackgroundView(msg: .todays_event_empty)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewHourlyEvents {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyEventTVC") as? HourlyEventTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            
//            cell.tableView.isHidden = self.selectedIndex != indexPath.row
            cell.lblHour.backgroundColor = .clear
            cell.tblMain = tableView
            cell.tableView.reloadData()

            cell.needToUpdate = false
            if let data = self.filterEventData.hourEvents?[indexPath.row] {
                cell.lblHour.backgroundColor = (data.events?.count ?? 0) != 0 ? .lightGray.withAlphaComponent(0.5) : .clear
                cell.setupDetails(data: data)
            }
            
//            cell.btnExpandClick = { [weak self] in
//                guard let self else { return }
//                self.selectedIndex = self.selectedIndex == indexPath.row ? -1 : indexPath.row
//                self.tableViewHourlyEvents.reloadData()
//                self.tableViewHourlyEvents.scrollToRow(at: indexPath, at: .top, animated: false)
//            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysEventsTVC") as? TodaysEventsTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let data = self.filterEventData.dayEvents?[indexPath.row] {
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
                    self.filterEventData = self.eventDetailsData
                    self.tableViewHourlyEvents.reloadData()
                    self.tableViewTodaysEvents.reloadData()
                    
                    DispatchQueue.main.async {
//                        if let count = self.eventDetailsData.hourEvents?.count, count != 0 {
//                            self.selectedIndex = 0
//                            self.tableViewHourlyEvents.reloadData()
//                            self.tableViewHourlyEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//                        }
                        
                        self.tableViewHourlyEvents.isHidden = false
                        self.tableViewTodaysEvents.isHidden = false
                    }
                }
            }
        }
    }
}
