//
//  BaseViews.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 07/06/23.
//

import UIKit

class BaseCustomView: UIView {

    // ----------------------------------------------------
    // MARK:
    // MARK: - Variables
    // ----------------------------------------------------
    public var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    var contentView: UIView?

    // ----------------------------------------------------
    // MARK:
    // MARK: - Override Functions
    // ----------------------------------------------------
    override init(frame fem: CGRect) {
        super.init(frame: fem)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    // ----------------------------------------------------
    // MARK:
    // MARK: - Custome Functions
    // ----------------------------------------------------
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
