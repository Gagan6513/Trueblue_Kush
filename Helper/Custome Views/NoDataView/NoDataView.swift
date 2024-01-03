//
//  NoDataView.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 07/06/23.
//

import UIKit

class NoDataView: BaseCustomView {

    // ----------------------------------------------------
    // MARK:
    // MARK: - deinit
    // ----------------------------------------------------
    deinit {
        print("Deinit \(NoDataView.self)")
//        noRecordFound
    }
    
    // ----------------------------------------------------
    // MARK:
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var titleLabel: UILabel!
    
    // ----------------------------------------------------
    // MARK:
    // MARK: - Variables
    // ----------------------------------------------------
    public var details: (String)? {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.details
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK:
    // MARK: - Override Functions
    // ----------------------------------------------------

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel.text = ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel.text = ""
    }
    
    // ----------------------------------------------------
    // MARK:
    // MARK: - Custome Functions
    // ----------------------------------------------------

}
