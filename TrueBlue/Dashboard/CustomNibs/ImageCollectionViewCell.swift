//
//  ImageCollectionViewCell.swift
//  TrueBlue
//
//  Created by Sharad Patil on 14/12/23.
//

import UIKit
protocol GalleryCellDelegate: AnyObject {
    func didTapDeleteButton(index: Int)
}
class ImageCollectionViewCell: UICollectionViewCell {
    weak var delegate: GalleryCellDelegate?
    var indexPath: IndexPath?
    @IBOutlet weak var cImageView: UIImageView!
    
    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var docLabel: UILabel!
    @IBAction func deleteImageTapped(_ sender: Any) {

        if let indexPath = indexPath {
            delegate?.didTapDeleteButton(index: indexPath.row)
        }

    }
}
