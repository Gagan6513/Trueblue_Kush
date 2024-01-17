//
//  AccidentManagementFourthVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit
import Applio

class AccidentManagementFourthVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(for: "ImagesCVC")
    }
    
    
}

extension AccidentManagementFourthVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCVC", for: indexPath) as? ImagesCVC else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 4, height: (collectionView.frame.width - 30) / 4)
    }
    
}
