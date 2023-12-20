//
//  DashboardVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 14/08/21.
//

import UIKit
import SideMenu
import Alamofire
class DashboardVC: UIViewController {
    let screenNames = ["Collections History","Delivery History","Return\nVehicle","Swap Vehicle","Available\nVehicles","Hired\nVehicles","Collection Note","Delivery Note","Upcoming Bookings", "Repairer Bookings"]
    let imageNames = ["collections","delivery","returnVehicle","swap","availableVehicle","hiredVehicle","hiredVehicle","hiredVehicle","hiredVehicle","hiredVehicle"]
    
    var arrSearchby = ["Reference No."/*, "Phone Number", "Email"*/]
    var searchbyPicker = UIPickerView()
    var searchTblView = UITableView()
    var searchResults = Int()
    var searchDashboardData = [SearchDashboardModelData]()
    var vehiclesDetailsData = [VehiclesDetailsModelData]()
    @IBOutlet weak var searchTextInPopup: UITextField!
    @IBOutlet weak var searchByTxtFld: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    var arrDashboardCount = ["0","0","0","0","0","0","0","0","0","0"]
    @IBOutlet weak var searchPopView: UIView!
    @IBOutlet weak var btnSearch:UIButton!
    
    @IBOutlet weak var serachStackView: UIStackView!
    var searchVal = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.LogoutNotificationAction(_:)), name: .logout, object: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            searchPopView.backgroundColor = .white
        } else {
            searchPopView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        btnSearch.setImage(UIImage(named: "search_white"), for: .normal)
        self.searchByTxtFld.text = self.arrSearchby[0]
        btnSearch.layer.cornerRadius = btnSearch.frame.height / 2
        setUpSearchTblView()
        hideKeyboardWhenTappedAround()
        apiGetRequest(parameters: nil, endPoint: EndPoints.DASHBOARD_COUNT)
        
        self.searchByTxtFld.inputView = self.searchbyPicker
        self.searchbyPicker.delegate = self
        self.searchbyPicker.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //API Call for logout
        checkStatusResults()
    }
    //    override func viewDidDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppSegue.DASHBOARD_SEARCH_RESULT_DETAILS {
            let destinationVC = segue.destination as! SearchDashboardResultDetailsVC
            destinationVC.searchValue = searchDashboardData[sender as! Int].searchResult
            destinationVC.searchResultObj = searchDashboardData[sender as! Int]
            destinationVC.vehiclesResultObj = vehiclesDetailsData
            searchTblView.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //To hide Search result table view when tapped outside it
        if !searchTblView.isHidden {
            let touch = touches.first
            if touch?.view != searchTblView || touch?.view != searchView {
                searchTblView.isHidden = true
            }
        }
    }
    func apiPostRequest(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DashboardViewModel()
        obj.delegate = self
        obj.postDashboard(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DashboardViewModel()
        obj.delegate = self
        obj.getDashboard(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func setUpSearchTblView(){
        searchTblView.delegate = self
        searchTblView.dataSource = self
        searchTblView.isHidden = true
        print(searchView.frame.maxY)
        print(searchView.superview?.frame)
        searchTblView.register(UITableViewCell.self, forCellReuseIdentifier: AppTblViewCells.SEARCH_DASHBOARD)
        //searchTblView.frame = CGRect(x: searchView.frame.minX, y: searchView.frame.height, width: searchView.frame.width, height: (searchView.frame.height * CGFloat(searchResults.count)))
        print(searchTblView.frame.minY)
        view.addSubview(searchTblView)
    }
    func getSearchResults() {
        if searchTxtFld.text!.isEmpty{
            showToast(strMessage: searchTextRequired)
            return
        }
        view.endEditing(true)
        let parameters : Parameters = ["search": searchTxtFld.text!]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SEARCH_DASHBOARD)
    }
    func checkStatusResults() {
        
        let parameters : Parameters = ["user_id": UserDefaults.standard.userId() ]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.CHECK_STATUS)
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.setUsername(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserId(value: "")
    }
    
    func clearSearchResults() {
        //searchResults.removeAll()
        searchDashboardData.removeAll()
        searchTblView.isHidden = true
        searchTblView.reloadData()
    }
    
    //    func hideSearchTblViewWhenTappedAround() {
    ////        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissSearchTblView))
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSearchTblView))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    //
    //    @objc func dismissSearchTblView() {
    //        searchTblView.isHidden = true
    //    }
    
    func getSearchResult() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH //.replacingOccurrences(of: "newapp", with: "app")
        let requestURL = newAPIPATH + EndPoints.SEARCH_REFERENCE
        let parameters : Parameters = ["searchvalue" : searchVal]
        //        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                
                CommonObject.sharedInstance.stopProgress()
                
                if let mainDict = response.value as? [String : AnyObject] {
                    
                    print(mainDict)
                    
                     
                    let status = mainDict["status"] as? Int ?? 0
                    if status == 1{
                        
                        self.searchPopView.isHidden = true
                        
                        CommonObject.sharedInstance.stopProgress()
                        
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        var storyboardName = String()
                        var vcid = String()
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            storyboardName = AppStoryboards.DASHBOARD
                            vcid = AppStoryboardId.REF_SEARCH_RESULT_VC
                            
                        } else {
                            storyboardName  = AppStoryboards.DASHBOARD_PHONE
                            vcid = AppStoryboardId.REF_SEARCH_RESULT_PHONE
                        }
                        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
                        let searchResultvc = storyboard.instantiateViewController(identifier: vcid) as! ReferenceSearchResultVC
                        searchResultvc.responseDict = dict
                        searchResultvc.modalPresentationStyle = .overFullScreen
                        self.present(searchResultvc, animated: true, completion: nil)
                        
                        
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
                             
            //                self.dismiss(animated: true, completion: nil)
                        }
            //            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                        alert.addAction(yesAction)
            //            alert.addAction(noAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                } else{
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    
                }
            }
        }
    }
    @IBAction func drawerBtn(_ sender: UIButton) {
        var vc = UIViewController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: AppStoryboardId.DRAWER)
        } else {
            vc = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: Bundle.main).instantiateViewController(withIdentifier: AppStoryboardId.DRAWER_PHONE)
        }
        
        //        let vc = storyboard!.instantiateViewController(withIdentifier: "sideMenu") as! SideMenuNavigationController
        let menu = SideMenuNavigationController(rootViewController: vc)
        //        SideMenuManager.default.leftMenuNavigationController = menu
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.2)
        menu.statusBarEndAlpha = 1
        menu.presentationStyle = .menuSlideIn
        menu.presentingViewControllerUserInteractionEnabled = false
        menu.presentationStyle.presentingEndAlpha = 0.5
        present(menu, animated: true, completion: nil)
        //        performSegue(withIdentifier: AppSegue.DRAWER, sender: nil)
    }
    //    @IBAction func createNewEntryBtn(_ sender: UIButton) {
    //        performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
    //    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        getSearchResults()
    }
    
    @IBAction func searchBottomButtonTapped(_ sender: Any) {
        searchPopView.isHidden = false
    }
    
    @IBAction func closeSearchPopupView(_ sender: Any) {
        searchTextInPopup.text = ""
        searchPopView.isHidden = true
    }
    
    @IBAction func searchBtnInSearchPopup(_ sender: Any) {
        if (searchVal.isEmpty){
            let alert = UIAlertController(title: "", message: addReferenceVal, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
                 
//                self.dismiss(animated: true, completion: nil)
            }
//            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
//            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            getSearchResult()
        }
        
    }
    @IBAction func searchTFInSearchPopup(_ sender: UITextField) {
        print("searchTFInSearchPopup")
    }
    
    @IBAction func searchValueInSearchPopup(_ sender: UITextField) {
        searchVal = sender.text!
        print("searchValueInSearchPopup")
    }
    @IBAction func referenceSearchKeyTapped(_ sender: Any) {
    }
    
    
    @objc func LogoutNotificationAction(_ notification: NSNotification) {
        
        let logoutAlert = UIAlertController(title: APP_NAME, message: confirmLogout, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.logout()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        logoutAlert.addAction(yesAction)
        logoutAlert.addAction(noAction)
        present(logoutAlert, animated: true, completion: nil)
        //        if let userInfo = notification.userInfo {
        //
        //           if let selectedDate = userInfo["selectedDate"] as? Bool {
        //
        //            }
        //        }
    }
    
    func logout(){
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcId = AppStoryboardId.LOGIN
        } else {
            vcId = AppStoryboardId.LOGIN_PHONE
        }
        self.clearUserDefaults()
        let vc = UIStoryboard(name: AppStoryboards.MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension DashboardVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchDashboardData.count)
        return searchDashboardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.SEARCH_DASHBOARD, for: indexPath)
        cell.textLabel?.text = searchDashboardData[indexPath.row].searchResult
        cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.contentView.layer.borderWidth = 1
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchDashboardData[indexPath.row].isSwapped != "" {
            performSegue(withIdentifier: AppSegue.DASHBOARD_SEARCH_RESULT_DETAILS, sender: indexPath.row )
        } else {
            performSegue(withIdentifier: AppSegue.DASHBOARD_SEARCH_RESULT_DETAILS, sender: indexPath.row )
        }
        //performSegue(withIdentifier: AppSegue.DASHBOARD_SEARCH_RESULT_DETAILS, sender: searchDashboardData[indexPath.row])
        // performSegue(withIdentifier: AppSegue.DASHBOARD_SEARCH_RESULT_DETAILS, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchView.frame.height
    }
}

extension DashboardVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            //if indexPath.row == screenNames.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.ADD_ITEM_CELL, for: indexPath as IndexPath) as! AddItemCell
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.DASHBOARD, for: indexPath as IndexPath) as! DashboardCvCell
            cell.imgView.image = UIImage(named: imageNames[indexPath.row-1])
            cell.detailLbl.text = arrDashboardCount[indexPath.row-1]
//            if arrDashboardCount[indexPath.row-1] == "1" {
//                cell.detailLbl.isHidden = true
//            } else {
                cell.detailLbl.isHidden = false
//            }
            cell.titleLbl.text = screenNames[indexPath.row-1]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            //iPad
            return CGSize(width: (collectionView.frame.size.width - 30)/3, height: (collectionView.frame.size.width - 30)/3)
        } else {
            //iPhone
            return CGSize(width: (collectionView.frame.size.width - 10)/2, height: (collectionView.frame.size.width - 20)/2)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            CommonObject.sharedInstance.isNewEntry = true
//            CommonObject.sharedInstance.currentReferenceId = ""
            performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
        case 1:
            performSegue(withIdentifier: AppSegue.COLLECTIONS, sender: nil)
        case 2:
            performSegue(withIdentifier: AppSegue.DELIVERIES, sender: nil)
        case 3:
            performSegue(withIdentifier: AppSegue.RETURN_VEHICLE, sender: nil)
        case 4:
//            performSegue(withIdentifier: AppSegue.SWAP_VEHICLE, sender: nil)

            let ctrl = UIStoryboard(name: "DashboardPhone", bundle: nil).instantiateViewController(withIdentifier: "NewSwapVehicleVC") as! NewSwapVehicleVC
            ctrl.modalPresentationStyle = .overFullScreen
            self.present(ctrl, animated: true)
            
        case 5:
            performSegue(withIdentifier: AppSegue.AVAIL_VEHICLE, sender: nil)
        case 6:
            performSegue(withIdentifier: AppSegue.HIRED_VEHICLE, sender: nil)
        case 7:
            performSegue(withIdentifier: AppSegue.COLLECTION_NOTE_LIST, sender: nil)
        case 8:
            performSegue(withIdentifier: AppSegue.DELIVERY_NOTE_LIST, sender: nil)
        case 9:
            performSegue(withIdentifier: AppSegue.UPCOMING_BOOKINGS, sender: nil)
        case 10:
            performSegue(withIdentifier: AppSegue.REPAIRER_BOOKINGS, sender: nil)
//            performSegue(withIdentifier: AppSegue.UNDER_MAINTENANCE_VEHICLES, sender: nil)
        case 11:
            CommonObject.sharedInstance.isNewEntry = true
            performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
        default:
            print("Unkown Selection")
        }
    }
}

extension DashboardVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case searchTxtFld:
            if searchTxtFld.text != textField.text {
                clearSearchResults()
            }
            
        default:
            print("Unkown Textfield")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case searchTxtFld:
            print(searchTxtFld.text)
            print(textField.text)
            if searchTxtFld.text == textField.text {
                clearSearchResults()
            }
            
        default:
            print("Unkown Textfield")
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTxtFld:
            getSearchResults()
        default:
            print("Unkown Textfield")
        }
        return true
    }
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        switch textField {
    //        case searchTxtFld:
    //            if searchTxtFld.text == "" || searchTxtFld.text == " " {
    //                searchResults.removeAll()
    //                searchTblView.isHidden = true
    //                searchTblView.reloadData()
    //            }
    //        default:
    //            print("Unkown Textfield")
    //        }
    //    }
}
extension DashboardVC : DashboardVMDelegate {
    func checkStatusAPISuccess(objData: CheckStatusModel, strMessage: String) {
        print(objData)
        if(objData.dictResult.profileStatus == "Inactive"){
            logout()
        }
    }
    
    func dashboardAPISuccess(objData: SearchDashboardModel, strMessage: String) {
        searchDashboardData.removeAll()
        objData.vehicleDetails
        print(objData.vehicleDetails)
        if objData.arrResult.count > 0 {
            searchDashboardData = objData.arrResult
            vehiclesDetailsData = objData.vehicleDetails
            
            //            for i in 0...objData.arrResult.count-1 {
            //                searchDashboardData.append(objData.arrResult[i])
            //                //searchDashboardData?.append(objData.arrResult[i].)
            //            }
            var estimatedHeight = searchView.frame.height * CGFloat(searchDashboardData.count)
            if estimatedHeight > view.frame.maxY {
                estimatedHeight = view.frame.maxY - searchView.frame.maxY - searchView.superview!.frame.minY - view.safeAreaInsets.bottom - 5
            }
            searchTblView.frame = CGRect(x: searchView.frame.minX, y: searchView.frame.maxY + (searchView.superview?.frame.minY)!, width: searchView.frame.width, height: estimatedHeight)
            searchTblView.isHidden = false
            print(searchTblView.frame)
            searchTblView.reloadData()
        }
    }
    
    func dashboardAPISuccess(objData: DashboardModel, strMessage: String) {
        print(objData.dictResult)
        arrDashboardCount[0] = objData.dictResult.numOfCollections
        arrDashboardCount[1] = objData.dictResult.numOfTodayDeliveries
        arrDashboardCount[4] = objData.dictResult.numOfAvailableVehicle
        arrDashboardCount[5] = objData.dictResult.numOfHiredVehicle
        arrDashboardCount[6] = objData.dictResult.todayCollectionNotes
        arrDashboardCount[7] = objData.dictResult.todayDeliveryNotes
        arrDashboardCount[8] = objData.dictResult.upcomingbookingcount
        arrDashboardCount[9] = objData.dictResult.repairerbookingcount
        //arrDashboardCount[6] = objData
        collectionView.reloadData()
        print(arrDashboardCount)
        //        numOfCollections = objData.dictResult.numOfCollections
        //        numOfHiredVehicle = objData.dictResult.numOfHiredVehicle
        //        numOfTodayDeliveries = objData.dictResult.numOfTodayDeliveries
        //        numOfAvailableVehicle = objData.dictResult.numOfAvailableVehicle
    }
    
    func dashboardAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        switch serviceKey {
        case EndPoints.SEARCH_DASHBOARD:
            clearSearchResults()
        default:
            print("Other Service Key")
        }
    }
    
    
}

extension DashboardVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.searchByTxtFld.text = self.arrSearchby[0]
        return self.arrSearchby.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrSearchby[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.searchByTxtFld.text = self.arrSearchby[row]
        self.searchTextInPopup.keyboardType = .default

//        if row == 1 {
//            self.searchTextInPopup.keyboardType = .phonePad
//        } else if row == 2 {
//            self.searchTextInPopup.keyboardType = .emailAddress
//        } else {
//            self.searchTextInPopup.keyboardType = .default
//        }
    }
    
}
