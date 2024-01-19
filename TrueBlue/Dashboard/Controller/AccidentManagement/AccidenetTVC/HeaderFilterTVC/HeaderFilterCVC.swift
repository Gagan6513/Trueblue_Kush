//
//  HeaderFilterCVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit

class HeaderFilterCVC: UICollectionViewCell {
    
    @IBOutlet weak var pageNumberView: UIView!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var leftProgress: UIView!
    @IBOutlet weak var rightProgress: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(index: Int, title: String) {
        self.pageNumber.text = "\(index)"
        self.pageTitle.text = title
     
    }

}
