//
//  NewBookingEntryVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 17/08/21.
//

import UIKit
import Alamofire

class NewBookingEntryVC: UIViewController {
    let tabSelections = ["Not At Fault Driver Details","At Fault Driver Details","Any Other Party Details","Upload Documents", "Notes"]//,"Notes"
    let tabSelectionsIndex = ["1","2","3","4", "5"]//,"5"
    var selectedRow = 0
    
    var formRefrenceID = ""
    var newBookingBackDelegate: NewBookingBackDelegate? = nil
    
    
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func openTab(currentTabIndex: Int) {
        var currentVc = String()
        switch currentTabIndex {
        case 0:
            if UIDevice.current.userInterfaceIdiom == .pad {
                currentVc = AppStoryboardId.NOT_AT_FAULT_DRIVER_DETAILS
            } else {
                currentVc = AppStoryboardId.NOT_AT_FAULT_DRIVER_DETAILS_PHONE
            }
        case 1:
            if UIDevice.current.userInterfaceIdiom == .pad {
                currentVc = AppStoryboardId.AT_FAULT_DRIVER_DETAILS
            } else {
                currentVc = AppStoryboardId.AT_FAULT_DRIVER_DETAILS_PHONE
            }
        case 2:
            if UIDevice.current.userInterfaceIdiom == .pad {
                currentVc = AppStoryboardId.ANY_OTHER_PARTY_DETAILS
            } else {
                currentVc = AppStoryboardId.ANY_OTHER_PARTY_DETAILS_PHONE
            }
        case 3:
            if UIDevice.current.userInterfaceIdiom == .pad {
                currentVc = AppStoryboardId.UPLOAD_DOCUMENTS
            } else {
                currentVc = AppStoryboardId.UPLOAD_DOCUMENTS_PHONE
            }
        case 4:
            if UIDevice.current.userInterfaceIdiom == .pad {
                currentVc = AppStoryboardId.NOTES_VC
            } else {
                currentVc = AppStoryboardId.NOTES_PHONE
            }
        default:
            print("Unkown Selection")
        }
        
        if self.children.count > 0 {
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        
        
        if !currentVc.isEmpty {
            var storyBoard = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyBoard = AppStoryboards.DASHBOARD
            } else {
                storyBoard = AppStoryboards.DASHBOARD_PHONE
            }
            let vc = UIStoryboard(name: storyBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: currentVc)
            embed(viewController: vc, inView: containerView)
        }
    }
    

    @IBAction func backBtn(_ sender: UIButton) {
        if CommonObject.sharedInstance.isDataChangedInCurrentTab {
            let alert = UIAlertController(title: "Warning!", message: unsavedData, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                CommonObject.sharedInstance.isDataChangedInCurrentTab = false
                if !UserDefaults.standard.GetReferenceId().isEmpty{
                    UserDefaults.standard.removeReferenceID()
                }
                self.dismiss(animated: true, completion: nil)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: alert_title, message: exitWithoutSave, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                if !UserDefaults.standard.GetReferenceId().isEmpty{
                    UserDefaults.standard.removeReferenceID()
                }
                self.dismiss(animated: true, completion: nil)
                self.newBookingBackDelegate?.dismissVC()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension NewBookingEntryVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabSelections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.NEW_BOOKING_ENTRY_TAB, for: indexPath as IndexPath) as! NewBookingEntryTabCvCell
        if selectedRow == indexPath.row {
            cell.contentView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.tabLbl.textColor = UIColor.white
            cell.tabIndexLbl.textColor = UIColor(named: AppColors.BLUE)
        } else {
            cell.tabLbl.textColor = UIColor(named: AppColors.DISABLED_TAB_TEXT)
            cell.contentView.backgroundColor = UIColor(named: AppColors.DISBLED_TAB_BACKGROUND)
            cell.tabIndexLbl.textColor = UIColor(named: AppColors.DISBLED_TAB_BACKGROUND)
        }
        cell.tabIndexLbl.text = tabSelectionsIndex[indexPath.row]
        cell.tabIndexLbl.layer.cornerRadius = cell.tabIndexLbl.frame.height / 2
        cell.tabIndexLbl.layer.masksToBounds = true
        cell.tabLbl.text = tabSelections[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.NEW_BOOKING_ENTRY_TAB, for: indexPath as IndexPath) as! NewBookingEntryTabCvCell
        let font = cell.tabLbl.font
        let estimatedWidth = tabSelections[indexPath.row].size(withAttributes: [.font: font]).width + cell.tabIndexLbl.frame.width + cell.tabIndexLbl.frame.minX + 15
//        if UIDevice.current.userInterfaceIdiom == .pad {
//                    return CGSize(width: estimatedWidth, height: collectionView.frame.size.height)
//        //            return CGSize(width: (collectionView.frame.size.width - 90)/2.4, height: collectionView.frame.size.height)
//                }
        collectionView.layoutIfNeeded()
        return CGSize(width: estimatedWidth
                      , height: collectionView.frame.size.height)
//        return CGSize(width: (collectionView.frame.size.width - 15)/2.4, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRow == indexPath.row {
            return
        }
        
        if CommonObject.sharedInstance.isNewEntry && UserDefaults.standard.GetReferenceId().isEmpty{
            showToast(strMessage: "Please save your details in Not at Fault Driver Details Screen")
            return
        }
        if CommonObject.sharedInstance.isDataChangedInCurrentTab {
            let alert = UIAlertController(title: "Warning!", message: unsavedData, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                CommonObject.sharedInstance.isDataChangedInCurrentTab = false
                self.openTab(currentTabIndex: indexPath.row)
                self.selectedRow = indexPath.row
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                collectionView.reloadData()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
        } else {
            openTab(currentTabIndex: indexPath.row)
            selectedRow = indexPath.row//To change selected tab colour
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }
}
