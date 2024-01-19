//
//  AccidentManagementVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit
import Applio

class AccidentManagementVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollViewPages: UIScrollView!
    
    var arrPage = ["Driver’s Details", "Other Party Details", "Accident Details", "Upload Documents", "Note List"]
    var currentIndex = 0
    
    var completedIndex = [0]
    
    var doneFormIndex = 0 {
        didSet {
            if doneFormIndex != 4 || doneFormIndex != 5 {
                let newX = CGFloat(self.doneFormIndex) * scrollViewPages.frame.width
                self.scrollViewPages.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
                self.collectionView.reloadData()
            }
        }
    }
    
    var applicationId: String? {
        didSet {
            DispatchQueue.main.async {
                self.scrollViewPages.isScrollEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollViewPages.isScrollEnabled = false
        self.setupUI()
        self.setupNotification()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
            
            if let doneFormIndex = (noti.userInfo as? NSDictionary)?.value(forKey: "currentIndex") as? Int {
                
                self.completedIndex.removeAll(where: {$0 == doneFormIndex})
                
                self.completedIndex.append(doneFormIndex)
                
                self.collectionView.reloadData()

                self.doneFormIndex = (doneFormIndex)
            }
        })
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AccidentManagementFirstVC") {
            
            let ctrl = segue.destination as! AccidentManagementFirstVC
            
        } else if (segue.identifier == "AccidentManagementSecondVC") {
            let _ = segue.destination as! AccidentManagementSecondVC
            print("AccidentManagementSecondVC")
        } else if (segue.identifier == "AccidentManagementThirdVC") {
            let _ = segue.destination as! AccidentManagementThirdVC
        } else if (segue.identifier == "AccidentManagementFourthVC") {
            let _ = segue.destination as! AccidentManagementFourthVC
        } else if (segue.identifier == "AccidentManagementFifthVC") {
            let ctrl = segue.destination as! AccidentManagementFifthVC
            ctrl.applicationId = "0"
        }
    }
    
    func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(for: "HeaderFilterCVC")
    }
}

extension AccidentManagementVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderFilterCVC", for: indexPath) as? HeaderFilterCVC else { return UICollectionViewCell() }
        
        cell.setupDetails(index: (indexPath.row + 1), title: self.arrPage[indexPath.row ])
        cell.leftProgress.isHidden = indexPath.row == 0
        cell.rightProgress.isHidden = indexPath.row == (self.arrPage.count - 1)
        
        if completedIndex.contains(indexPath.row) {
            cell.pageNumberView.backgroundColor = indexPath.row == self.currentIndex ? UIColor(named: "F39C12") : UIColor(named: "07B107")
            cell.leftProgress.backgroundColor = UIColor(named: "07B107")
            cell.rightProgress.backgroundColor = UIColor(named: "07B107")
        } else {
            cell.pageNumberView.backgroundColor = UIColor(named: "8E8E8E")
            cell.leftProgress.backgroundColor = UIColor(named: "8E8E8E")
            cell.rightProgress.backgroundColor = UIColor(named: "07B107")
        }
        
        if completedIndex.contains(indexPath.row) {
            cell.leftProgress.backgroundColor = UIColor(named: "07B107")
        } else {
            cell.leftProgress.backgroundColor = UIColor(named: "8E8E8E")
        }
        
        if completedIndex.contains(indexPath.row + 1) {
            cell.rightProgress.backgroundColor = UIColor(named: "07B107")
        } else {
            cell.rightProgress.backgroundColor = UIColor(named: "8E8E8E")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width) / CGFloat(self.arrPage.count)), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if applicationId != nil {
            if completedIndex.contains(indexPath.row) {
                self.currentIndex = indexPath.row
                
                let newX = CGFloat(self.currentIndex) * scrollViewPages.frame.width
                scrollViewPages.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
                
                collectionView.reloadData()
            }

        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollViewPages {
            let pageCGFloat = scrollView.contentOffset.x / scrollView.bounds.width
            let pageIndexInt = pageCGFloat.rounded(.toNearestOrAwayFromZero)
            if pageIndexInt >= 0 {
                self.currentIndex = Int(pageIndexInt)
                self.collectionView.reloadData()
            }
        }
    }
}
