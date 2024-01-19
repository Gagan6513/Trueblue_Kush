//
//  ImagesCVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit

class ImagesCVC: UICollectionViewCell {

    @IBOutlet weak var docImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(data: uploadedImagesModel) {
        if let url = URL(string: data.image_url ?? "") {
            self.docImage.sd_setImage(with: url)
        }
    }

}
