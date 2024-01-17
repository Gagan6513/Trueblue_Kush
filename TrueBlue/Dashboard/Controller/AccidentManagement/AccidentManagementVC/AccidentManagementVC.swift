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
    
    var arrPage = ["Driver’s Details", "Other Party Details", "Accident Details", "Upload Documents", "Note List"]
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(for: "HeaderFilterCVC")
    }
}

extension AccidentManagementVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderFilterCVC", for: indexPath) as? HeaderFilterCVC else { return UICollectionViewCell() }
        
        cell.setupDetails(index: (indexPath.row + 1), title: self.arrPage[indexPath.row ])
        cell.leftProgress.isHidden = indexPath.row == 0
        cell.rightProgress.isHidden = indexPath.row == (self.arrPage.count - 1)
        
        cell.pageNumberView.backgroundColor = indexPath.row == self.currentIndex ? UIColor(named: "F39C12") : UIColor(named: "07B107")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width) / CGFloat(self.arrPage.count)), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        collectionView.reloadData()
    }
    
}
