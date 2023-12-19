//
//  SwapVehicleVC.swift
//  DesignExample
//
//  Created by Kushkumar Katira on 18/12/23.
//

import UIKit
import Applio
import Alamofire
import DKImagePickerController

class NewSwapVehicleVC: UIViewController {

    @IBOutlet weak var CarImageCollectionView: UICollectionView!
    
    @IBOutlet weak var txtRefNo: UITextField!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtModelInfo: UITextField!
    @IBOutlet weak var txtMilageOut: UITextField!
    @IBOutlet weak var txtMilageIn: UITextField!
    
    @IBOutlet weak var txtDateOut: UITextField!
    @IBOutlet weak var txtTimeOut: UITextField!
    
    @IBOutlet weak var txtDateIn: UITextField!
    @IBOutlet weak var txtTimeIn: UITextField!
    
    @IBOutlet weak var txtReasonForReplacement: UITextView!
    
    @IBOutlet weak var newcarImage: UIImageView!
    @IBOutlet weak var txtNewVehivleRefNo: UITextField!
    @IBOutlet weak var txtNewModelInfo: UITextField!
    @IBOutlet weak var txtNewMileageOut: UITextField!
    @IBOutlet weak var txtNewDateOut: UITextField!
    @IBOutlet weak var txtNewTimeOut: UITextField!
    
    var applicationID = String()//We get this from Collections Screen
    var arrHiredVehicle = [HiredVehicleDropdownListModelData]()
    var arrReturnUploadedDocs = [DocumentDetailsModelData]()
    var arrCarImages = [fleet_docs]()
    var selectedDropdownItemIndex = -1 as Int

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupUI()
    }
    
    func setupCollectionView() {
        self.CarImageCollectionView.delegate = self
        self.CarImageCollectionView.dataSource = self
        self.CarImageCollectionView.registerNib(for: "CarImageCVC")
    }
    
    @IBAction func btnChooseRefNo(_ sender: Any) {
        if applicationID.isEmpty {
            //User comes from dashboard
            if arrHiredVehicle.count > 0 {
                var temp = [String] ()
                for i in 0...arrHiredVehicle.count-1 {
                    
                    if arrHiredVehicle[i].registration_no != "" {
                        temp.append(arrHiredVehicle[i].refno.appendingFormat(" - %@", arrHiredVehicle[i].registration_no))
                    }else {
                        temp.append(arrHiredVehicle[i].refno)
                    }
                }
                showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.RETURN_VEHICLE_REGO, notificationName: .searchListReturnVehicle)
            } else {
                showToast(strMessage: noRecordAvailable)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
    }
    
    func setupUI() {
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_DROPDOWN_LIST)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListReturnVehicle, object: nil)
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedItem = userInfo["selectedItem"] as? String {
            
            selectedDropdownItemIndex = userInfo["selectedIndex"] as! Int
            print(selectedDropdownItemIndex)
            
            switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.RETURN_VEHICLE_REGO:
                txtRefNo.text = selectedItem
                txtMilageOut.text = arrHiredVehicle[selectedDropdownItemIndex].Mileage_out
                txtDateOut.text = arrHiredVehicle[selectedDropdownItemIndex].date_out
                print(arrHiredVehicle[selectedDropdownItemIndex])
                txtTimeOut.text = arrHiredVehicle[selectedDropdownItemIndex].time_out
                txtModelInfo.text = arrHiredVehicle[selectedDropdownItemIndex].vehicle_make + arrHiredVehicle[selectedDropdownItemIndex].vehicle_model
                self.arrCarImages = arrHiredVehicle[selectedDropdownItemIndex].fleet_docs
                self.CarImageCollectionView.reloadData()
                
                let parameters : Parameters = ["application_id" :arrHiredVehicle[selectedDropdownItemIndex].refno ]
                apiPostRequest(parameters: parameters, endPoint: EndPoints.RETURNUPLOADED_DOCS)

                default:
                print("Unkown List")
                }
            }
        }
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func setUpData() {
        if !applicationID.isEmpty {
            // User comes from collection screen
            for i in 0...arrHiredVehicle.count-1 {
                if applicationID == arrHiredVehicle[i].refno {
                    txtRefNo.text = arrHiredVehicle[i].refno + "-" + arrHiredVehicle[i].registration_no
                    txtMilageOut.text = arrHiredVehicle[i].Mileage_out
                    txtDateOut.text = arrHiredVehicle[i].date_out
                    txtTimeOut.text = arrHiredVehicle[i].time_out
                    txtModelInfo.text = arrHiredVehicle[i].vehicle_make + arrHiredVehicle[i].vehicle_model
                    self.arrCarImages = arrHiredVehicle[i].fleet_docs
                    self.CarImageCollectionView.reloadData()
//                    let timeOut = arrHiredVehicle[i].time_out
//                    timeOutSegmentedControl.setUpAmPM(time: timeOut)
//                    timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
                }
            }
        }
    }
    
}

extension NewSwapVehicleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarImageCVC", for: indexPath) as? CarImageCVC else { return UICollectionViewCell() }
        cell.carImages.sd_setImage(with: URL(string: self.arrCarImages[indexPath.row].image_url ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 18) / 4, height: (collectionView.frame.width - 18) / 4)
    }
    
}

extension NewSwapVehicleVC : ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        arrReturnUploadedDocs = objData.documentDetails
//        CarImageCollectionView.reloadData()
    }
    
    
    func returnVehicleAPISuccess(objData: ReturnVehicleModel, strMessage: String) {
//        print(objData)
//        showToast(strMessage: strMessage)
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
//            self.dismiss(animated: true)
//        })
    }
    
    
    func returnVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
        arrHiredVehicle = objData.arrResult
        setUpData()
        
        
        
        //print(arrHiredVehicle)
    }
    
    func returnVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
