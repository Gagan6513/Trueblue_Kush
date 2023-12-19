//
//  SwapVehicleVC.swift
//  DesignExample
//
//  Created by Kushkumar Katira on 18/12/23.
//

import UIKit
import Applio

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.CarImageCollectionView.delegate = self
        self.CarImageCollectionView.dataSource = self
        self.CarImageCollectionView.registerNib(for: "CarImageCVC")
    }
    
}

extension NewSwapVehicleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarImageCVC", for: indexPath) as? CarImageCVC else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 18) / 4, height: (collectionView.frame.width - 18) / 4)
    }
    
}
