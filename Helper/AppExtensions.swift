//
//  AppExtensions.swift
//  TrueBlue
//
//  Created by Raj Mohan on 17/08/21.
//

import Foundation
import UIKit
import Toast_Swift
extension UIView {
func round(corners: UIRectCorner, cornerRadius: Double) {
    //Diksha Rattan:For making specific corners of view round
    let size = CGSize(width: cornerRadius, height: cornerRadius)
    let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = self.bounds
    shapeLayer.path = bezierPath.cgPath
    self.layer.mask = shapeLayer
    }
}

public func debugLog(_ object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
  #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    debugPrint("<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n")
  #endif
}

extension Notification.Name {
    static let logout = Notification.Name("logout")
    static let dateCollections = Notification.Name("dateCollections")
    static let dateDeliveries = Notification.Name("dateDeliveries")
    static let searchUser = Notification.Name("searchUser")
    static let searchCollectedByUser = Notification.Name("searchCollectedByUser")
    static let searchDeleiveredByUser = Notification.Name("searchDeleiveredByUser")
    static let noteType = Notification.Name("noteType")
    static let searchReferenceNo = Notification.Name("searchReferenceNo")
    static let dateReturnVehicle = Notification.Name("dateReturnVehicle")
    static let timeReturnVehicle = Notification.Name("timeReturnVehicle")
    static let searchListReturnVehicle = Notification.Name("searchListReturnVehicle")
//    static let listSwapVehicle = Notification.Name("listSwapVehicle")
    static let dateSwapVehicle = Notification.Name("dateSwapVehicle")
    static let timeSwapVehicle = Notification.Name("timeSwapVehicle")
    static let searchListSwapVehicle = Notification.Name("searchListSwapVehicle")
//    static let listNotAtFault = Notification.Name("listNotAtFault")
    static let dateNotAtFault = Notification.Name("dateNotAtFault")
    static let timeNotAtFault = Notification.Name("timeNotAtFault")
    static let searchListNotAtFault = Notification.Name("searchListNotAtFault")
    static let searchListState = Notification.Name("searchListState")
//    static let listAtFault = Notification.Name("listAtFault")
    static let dateAtFault = Notification.Name("dateAtFault")
    static let searchListAtFault = Notification.Name("searchListAtFault")
//    static let listAnyOtherParty = Notification.Name("listAnyOtherParty")
    static let dateAnyOtherParty = Notification.Name("dateAnyOtherParty")
    static let searchListAnyOtherParty = Notification.Name("searchListAnyOtherParty")
    static let listDocuments = Notification.Name("listDocuments")
    static let reloadUploadDocuments = Notification.Name("reloadUploadDocuments")
    static let searchListBookingDetails = Notification.Name("searchListBookingDetails")
    static let deliveredCollectedBy = Notification.Name("deliveredCollectedby")
    static let listBookingDetails = Notification.Name("listBookingDetails")
    static let dateBookingDetails = Notification.Name("dateBookingDetails")
    static let timeBookingDetails = Notification.Name("timeBookingDetails")
    static let listCardDetails = Notification.Name("listCardDetails")
    static let digitalSignature = Notification.Name("digitalSignature")
    static let listAddHirer = Notification.Name("listAddHirer")
    static let dateAddHirer = Notification.Name("dateAddHirer")
    static let dateOfSettlement = Notification.Name("dateOfSettlementTxtFld")
    static let deliveryDate = Notification.Name("deliveryDate")
    static let collectionDate = Notification.Name("collectionDate")
    static let searchListRego = Notification.Name("regoList")
    static let searchListRA = Notification.Name("RAList")
    static let searchListRepairer = Notification.Name("repairerList")
    static let searchListReferral = Notification.Name("referralList")
    
    static let eventListRefresh = Notification.Name("eventListRefresh")
    
    static let deliveryNoteListRefresh = Notification.Name("deliveryNoteListRefresh")
    static let collectionNoteListRefresh = Notification.Name("collectionNoteListRefresh")
    //    static let returnVehicleDetails = Notification.Name("returnVehicleDetails")
    
    
    static let AccidentDetails = Notification.Name("AccidentDetails")
    static let refreshFleetList = Notification.Name("refreshFleetList")
    static let AccidentDetailsEdit = Notification.Name("AccidentDetailsEdit")
    
    
    
}
extension UIViewController {
    
    func showAlertWithAction(title: String ,messsage: String, isOkClicked: @escaping (() -> Void)) {
        //Diksha Rattan:Function for alert messages
        let alertController = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
            isOkClicked()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String ,messsage: String) {
        //Diksha Rattan:Function for alert messages
        let alertController = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showToast(strMessage: String) {
    //    ToastManager.shared.isQueueEnabled = true//Diksha Rattan:Makes sure all toast are displayed in queue and not at same time
        //Diksha Rattan:Fetch top most window if keyboard is on. Only works when keyboard is on
        var style = ToastStyle()
        style.messageAlignment = .center
        if UIDevice.current.userInterfaceIdiom == .pad {
            style.messageFont = UIFont(name: "Helvetica", size: 30)!
            style.activitySize = CGSize(width: 200, height: 200)
            style.horizontalPadding = 15
        } else {
            style.messageFont = UIFont(name: "Helvetica", size: 16)!
        }
        
        if KeyboardStateListener.shared.isVisible {
            //Diksha Rattan:Keyboard is active
            //Diksha Rattan:Making toast on the top window
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(strMessage,duration: 3.0, position: .bottom, style: style)
        } else {
            //Diksha Rattan:Keyboard is inactive
            view.makeToast(strMessage,duration: 3.0, position: .bottom, style: style)//Diksha Rattan: Making Toast on view of View Controller
        }
    }
    
    func showAlert(title: String = alert_title, message: String, yesTitle: String, noTitle: String, yesAction: @escaping ()->Void, noAction: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: yesTitle, style: .default) { _ in
            yesAction()
        }
        let noAction = UIAlertAction(title: noTitle, style: .default, handler: { _ in
            noAction()
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func isSegmentIndexChanged() {
        CommonObject.sharedInstance.isDataChangedInCurrentTab = true
    }
    

    func embed(viewController:UIViewController, inView view:UIView){
        
   
        //To embed View Controller inside a view
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func showPickerViewPopUp(list: [String],listNameForSelection: String,notificationName: Notification.Name) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_ITEM
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_ITEM_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: vcId) as! SelectItemVC
        alertVc.pickerViewData = list
        alertVc.modalPresentationStyle = .overFullScreen
        alertVc.listName = listNameForSelection
        alertVc.currentNotification = notificationName
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    
    func showSearchListPopUp(listForSearch: [String],listNameForSearch: String,notificationName: Notification.Name) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SEARCH_LIST
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SEARCH_LIST_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: vcId) as! SearchListVC
        alertVc.listForSearch = listForSearch
        alertVc.listNameForSearch = listNameForSearch
        alertVc.currentNotification = notificationName
        alertVc.modalPresentationStyle = .overFullScreen
//        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    
    func showDatePickerPopUp(textField: UITextField,notificationName: Notification.Name, _isFromUpcomingBooking:Bool = false, _isThreeYearsValidation:Bool = false, isFromDateOfBirth:Bool = false) {
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
        let alertVc = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        alertVc.dateTextField = textField
        alertVc.modalPresentationStyle = .overFullScreen
        alertVc.currentNotification = notificationName
        alertVc.isFromDateOfBirth = isFromDateOfBirth

//        alertVc.isFromUpcomingBooking = _isFromUpcomingBooking
        alertVc.isThreeYearsValidation = _isThreeYearsValidation
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    func showTimePickerPopUp(textField: UITextField,notificationName: Notification.Name) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_TIME
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_TIME_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: vcId) as! SelectTimeVC
        alertVc.timeTextField = textField
        alertVc.modalPresentationStyle = .overFullScreen
        alertVc.currentNotification = notificationName
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func displayImageOnFullScreen(imgUrl: String) {
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
        alertVc.imageUrlForDisplay =  imgUrl
        alertVc.modalPresentationStyle = .overFullScreen
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    
    func displayImageOnFullScreen(img: UIImage) {
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
        alertVc.imgForDisplay = img
        alertVc.modalPresentationStyle = .overFullScreen
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    
    func setAllImages(currentImg: String, allImages: [String], currentIndex: Int) {
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
        alertVc.imageUrlForDisplay =  currentImg
        
        alertVc.imageArray = allImages
        alertVc.currenIndex = currentIndex
        alertVc.modalPresentationStyle = .overFullScreen
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
    
    func setAllImages(currentImg: UIImage, allImages: [UIImage], currentIndex: Int) {
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
        alertVc.imgForDisplay =  currentImg
        alertVc.imageArr = allImages
        alertVc.currenIndex = currentIndex
        alertVc.modalPresentationStyle = .overFullScreen
        view.endEditing(true)//To remove any keyboard that were open on other texfield
        present(alertVc, animated: true, completion: nil)
    }
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIImage {
    func resizeImage(image: UIImage, newWidth: CGFloat,newHeight : CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
extension UITextField {
    //Ensures name entered has valid characters.Call this in should change characters delegate of textfield
    func isValidNameCharacter(characterTyped string: String,range: NSRange) ->Bool {
        var isAllowed = true
        //To avoid getting . in name after typing double spaces between characters
        if self.text?.last == " " && string == " " {
            text = (text as NSString?)?.replacingCharacters(in: range, with: " ")
            if let pos = position(from: beginningOfDocument, offset: range.location + 1) {
                // updates the text caret to reflect the programmatic change to the textField
                selectedTextRange = textRange(from: pos, to: pos)
                isAllowed = false
            }
        }
        let allowedCharacters = CharacterSet.letters
        let allowedCharacters1 = CharacterSet.whitespaces
        let characterSet = CharacterSet(charactersIn: string)
        isAllowed = isAllowed && allowedCharacters.isSuperset(of: characterSet) || allowedCharacters1.isSuperset(of: characterSet)
        return isAllowed
    }
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    func validateDateTyped(shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let obj = DateTextField()
        obj.textField = self
        obj.separator = "-"
        obj.dateFormat = .dayMonthYear
        return obj.dateTxtFld(shouldChangeCharactersIn: range, replacementString: string)
    }
    func validateCardExpiryDateTyped(shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let obj = DateTextField()
        obj.textField = self
        obj.separator = "-"
        obj.dateFormat = .monthYear
        return obj.dateTxtFld(shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func validateTimeTyped(shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let obj = DateTextField()
        obj.textField = self
        obj.separator = ":"
        return obj.timeTxtFld(shouldChangeCharactersIn: range, replacementString: string)
    }

    //To add format card number like XXXX XXXX XXXX XXXX
    func formatCardNumber(shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let replacementStringIsLegal = string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789").inverted) == nil
        
        if !replacementStringIsLegal {
            return false
        }
        
        let newString = (self.text! as NSString).replacingCharacters(in: range, with: string)
        let components = newString.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        if length == 0 || (length > 16 && !hasLeadingOne) || length > 19 {
            let newLength = (self.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 16) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        if length - index > 4 {
            let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
            formattedString.appendFormat("%@ ", prefix)
            index += 4
        }
        
        if length - index > 4 {
            let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
            formattedString.appendFormat("%@ ", prefix)
            index += 4
        }
        if length - index > 4 {
            let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
            formattedString.appendFormat("%@ ", prefix)
            index += 4
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        self.text = formattedString as String
        return false
    }
    
}


extension String {
    func isValidEmailAddress() -> Bool {
            var returnValue = true
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        returnValue = __emailPredicate.evaluate(with: self)
        return  returnValue
    }
    
    func isValidExpiryDateFormat()-> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yy"
        var isValid = false
        if let enteredDate = dateFormatter.date(from: self) {
            let result = Calendar.current.compare(Date(), to: enteredDate, toGranularity: .month)
            if result == .orderedSame {
                print("valid")
                isValid = true
            } else if result == .orderedAscending {
                print("valid")
                isValid = true
            } else if result == .orderedDescending {
                print("expired")
                isValid = false
            }
            
        }
        return isValid
    }
    //Converts 12 hour to 24 hour
    func convertTimeToTwentyFourHr(isAM: Int ) -> String {
        let comp = self.components(separatedBy: ":")
        let hour = comp.first ?? ""
        let minutes = comp.last ?? ""
//        var hourInt = Int(hour) ?? 0
        if var hourInt = Int(hour) {
            if isAM == 0 &&  hourInt == 12 {
                hourInt = 0
            } else if isAM == 1 && hourInt < 12 {
                hourInt += 12
            }
            var strHour = String(hourInt)
            if strHour.count == 1 {
                strHour = "0\(strHour)"
            }
            return "\(strHour):\(minutes)"
        }
        return ""
    }
//    func isValidName() -> Bool {
//        do {
//            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
//            if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
//                return false
//            }
//        }
//        catch {
//            print("ERROR")
//        }
//        return true
//    }
    
    
}

extension String {
    var DatePresentable: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.date(from: self)
        }
    }
    
    func date(from format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    func date(currentFormate: DateFormat = .yyyymmdd, convetedFormate: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate.rawValue
        guard let date = dateFormatter.date(from: self) else { return "NA" } 
        dateFormatter.dateFormat = convetedFormate.rawValue
        return dateFormatter.string(from: date)
    }
    
    func isTimeAM()-> Bool {
        if let value = self.DatePresentable?.getDateAccoringTo(format: .amPm) {
            if value.first?.lowercased() ?? "" == "a" {
                return true
            }
        }
        return false
    }
    
//    func yearsUptoNow(from startDate: Date) -> Int? {
//        let now = Date()
//        let calendar = Calendar.current
//
//        let ageComponents = calendar.dateComponents([.year], from: startDate, to: now)
//        let age = ageComponents.year
//        return age
//    }
    
    func calculateAge(format:String) -> (year :Int, month : Int, day : Int){
        let df = DateFormatter()
        df.dateFormat = format
        let date = df.date(from: self)
        guard let val = date else{
            return (0, 0, 0)
        }
        var years = 0
        var months = 0
        var days = 0
        
        let cal = Calendar.current
        years = cal.component(.year, from: Date()) -  cal.component(.year, from: val)
        
        let currMonth = cal.component(.month, from: Date())
        let birthMonth = cal.component(.month, from: val)
        
        //get difference between current month and birthMonth
        months = currMonth - birthMonth
        //if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0
        {
            years = years - 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: Date()) < cal.component(.day, from: val){
                months = months - 1
            }
        } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: val)
        {
            years = years - 1
            months = 11
        }
        
        //Calculate the days
        if cal.component(.day, from: Date()) > cal.component(.day, from: val){
            days = cal.component(.day, from: Date()) - cal.component(.day, from: val)
        }
        else if cal.component(.day, from: Date()) < cal.component(.day, from: val)
        {
            let today = cal.component(.day, from: Date())
            let date = cal.date(byAdding: .month, value: -1, to: Date())
            
            days = date!.daysInMonth - cal.component(.day, from: val) + today
        } else
        {
            days = 0
            if months == 12
            {
                years = years + 1
                months = 0
            }
        }
        
        return (years, months, days)
    }
    
    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Date {
    func getDateAccoringTo(format: DateFormat ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    var daysInMonth:Int {
            let calendar = Calendar.current
            
            let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
            let date = calendar.date(from: dateComponents)!
            
            let range = calendar.range(of: .day, in: .month, for: date)!
            let numDays = range.count
            
            return numDays
        }
}

enum DateFormat: String {
    case mmddyyyy = "MM/dd/yyyy"
    case mmmd_yyyy = "MMM d, yyyy"
    case yyyymmdd = "yyyy-MM-dd"
    case ddMMMMyyyy = "dd MMM, yyyy"
    
    case ddmmyyyy = "dd-MM-yyyy"
    case MM = "MM"
    case YYYY = "yyyy"
    case yyyymmdd_hhmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyymmdd_hhmmss_s = "yyyy-MM-dd HH:mm:ss.s"
    case yyyymmdd_hhmmss_sss = "yyyy-MM-dd HH:mm:ss.SSS"
    case yyyymmdd_hhmmaa = "yyyy-MM-dd hh:mm a"
    case ddmmyyyy_hhmmaa = "dd-MM-yyyy hh:mm a"
    case hhmmss = "HH:mm:ss"
    case Time12Hr_am = "hh:mm a"
    case TIME_am = "HH:mm a"
    case Time12Hr = "hh:mm"
    case amPm = "a"
}

extension UISegmentedControl {
    func setUpAmPmSegmentedControl() {
        self.setTitle("AM", forSegmentAt: 0)
        self.setTitle("PM", forSegmentAt: 1)
        var font = UIFont()
        if UIDevice.current.userInterfaceIdiom == .pad  {
            font = UIFont.systemFont(ofSize: 20)
        } else {
            font = UIFont.systemFont(ofSize: 10)
        }
        self.selectedSegmentTintColor = UIColor(named: AppColors.BLACK)
        self.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor(named: AppColors.BLACK) ?? .black], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    func setUpAmPM(time: String) {
        if time.isTimeAM() {
            self.selectedSegmentIndex = 0
        } else {
            self.selectedSegmentIndex = 1
        }
    }
}

extension UIImage {
    static let checkSelected = UIImage(named: "checkSelected")!
    static let checkUnselected = UIImage(named: "checkUnselected")!
}

enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay

    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]

    var regex : String {
        switch self {
        case .Amex:
           return "^3[47][0-9]{5,}$"
        case .Visa:
           return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
           return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
           return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
           return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
           return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
           return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
           return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
           return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
           return ""
        }
    }
}

public enum CreditCardType: String {
    case amex = "^3[47][0-9]{5,}$"
    case visa = "^4[0-9]{6,}$"
    case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
    case maestro = "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
    case dinersClub = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
    case jcb = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
    case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
    case unionPay = "^62[0-5]\\d{13,16}$"
    case mir = "^2[0-9]{6,}$"

    /// Possible C/C number lengths for each C/C type
    /// reference: https://en.wikipedia.org/wiki/Payment_card_number
    var validNumberLength: IndexSet {
        switch self {
        case .visa:
            return IndexSet([13,16])
        case .amex:
            return IndexSet(integer: 15)
        case .maestro:
            return IndexSet(integersIn: 12...19)
        case .dinersClub:
            return IndexSet(integersIn: 14...19)
        case .jcb, .discover, .unionPay, .mir:
            return IndexSet(integersIn: 16...19)
        default:
            return IndexSet(integer: 16)
        }
    }
}

public struct CreditCardValidator {
    
    /// Available credit card types
    private let types: [CreditCardType] = [
        .amex,
        .visa,
        .masterCard,
        .maestro,
        .dinersClub,
        .jcb,
        .discover,
        .unionPay,
        .mir
    ]
    
    private let string: String
    
    /// Create validation value
    /// - Parameter string: credit card number
    public init(_ string: String) {
        self.string = string.numbers
    }
    
    /// Get card type
    /// Card number validation is not perfroms here
    public var type: CreditCardType? {
        types.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: string.numbers
                )
        }
    }
    
    /// Calculation structure
    private struct Calculation {
        let odd, even: Int
        func result() -> Bool {
            (odd + even) % 10 == 0
        }
    }
    
    /// Validate credit card number
    public var isValid: Bool {
        guard let type = type else { return false }
        let isValidLength = type.validNumberLength.contains(string.count)
        return isValidLength && isValid(for: string)
    }
    
    /// Validate card number string for type
    /// - Parameters:
    ///   - string: card number string
    ///   - type: credit card type
    /// - Returns: bool value
    public func isValid(for type: CreditCardType) -> Bool {
        isValid && self.type == type
    }
    
    /// Validate string for credit card type
    /// - Parameters:
    ///   - string: card number string
    /// - Returns: bool value
    private func isValid(for string: String) -> Bool {
        string
            .reversed()
            .compactMap({ Int(String($0)) })
            .enumerated()
            .reduce(Calculation(odd: 0, even: 0), { value, iterator in
                return .init(
                    odd: odd(value: value, iterator: iterator),
                    even: even(value: value, iterator: iterator)
                )
            })
            .result()
    }
    
    private func odd(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 != 0 ? value.odd + (iterator.element / 5 + (2 * iterator.element) % 10) : value.odd
    }

    private func even(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 == 0 ? value.even + iterator.element : value.even
    }
    
}

fileprivate extension String {
 
    var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
}

extension UIColor {
    static let AppGrey = "#6C6C6C".hexStringToUIColor()
}

func showGlobelAlert(title: String?,
                     msg: String,
                     doneButtonTitle: String? = "Okay",
                     cancelButtonTitle: String? = "",
                     doneAction: ((Bool) -> Void)? = nil,
                     cancelAction: ((Bool) -> Void)? = nil) {
    
    let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
    dialogMessage.addAction(UIAlertAction(title: doneButtonTitle, style: .default, handler: { action in
        print("action done handler")
        doneAction?(true)
    }))
    if cancelButtonTitle != "" {
        dialogMessage.addAction(UIAlertAction(title: cancelButtonTitle, style: .destructive, handler: { action in
            print("action cancel handler")
            cancelAction?(true)
        }))
    }
    if let topController = UIApplication.topViewController() {
        topController.present(dialogMessage, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
