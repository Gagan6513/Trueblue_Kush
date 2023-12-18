//
//  CardView.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 21/08/21.
//

import UIKit

class CardView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.masksToBounds = false
        layer.shadowRadius = 4//10
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor(named: AppColors.DISABLED_TAB_TEXT)?.cgColor
        layer.shadowOffset = CGSize(width: 2 , height: 2)
        //layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,y: bounds.maxY - layer.shadowRadius, width: bounds.width, height: layer.shadowRadius)).cgPath
        layer.cornerRadius =  6.6
//        layer.backgroundColor = UIColor(named: AppColors.INPUT_BACKGROUND)?.cgColor
//        layer.borderWidth = 1
//        layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        //setTitleColor(UIColor.white , for: UIControl.State.normal)
    }

}
