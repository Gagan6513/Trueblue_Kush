//
//  ImagesCVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit

class ImagesCVC: UICollectionViewCell {

    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var deleteButtonClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(data: uploadedImagesModel) {
        if let url = URL(string: data.image_url ?? "") {
            self.docImage.sd_setImage(with: url)
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        showGlobelAlert(title: alert_title, msg: "Are you sure you want to delete this document.", doneButtonTitle: "No", cancelButtonTitle: "Yes", cancelAction: { [weak self] _ in
            guard let self else { return }
            self.deleteButtonClicked?()
        })
    }
    
}
