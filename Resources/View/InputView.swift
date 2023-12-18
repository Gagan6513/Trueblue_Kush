//
//  InputView.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import UIKit

class InputView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.masksToBounds = false
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 2
//        layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOffset = CGSize(width: 2 , height: 2)
        //layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,y: bounds.maxY - layer.shadowRadius, width: bounds.width, height: layer.shadowRadius)).cgPath
        layer.cornerRadius =  14
        layer.backgroundColor = UIColor(named: AppColors.INPUT_BACKGROUND)?.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        //setTitleColor(UIColor.white , for: UIControl.State.normal)
    }

}
