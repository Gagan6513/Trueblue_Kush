//
//  TableView+Extention.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 02/06/23.
//

import Foundation
import UIKit

extension UITableView {
    
    /* for register tableView cell xib
     self.tableView.registerNib(nibName: "UITableViewCell")
     */
    public func registerNib(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /* for set background view ( No data view ) */
    public func setBackgroundView(msg: NoData) {
        let bgView = NoDataView(frame: self.frame)
        bgView.frame = self.frame
        bgView.details = (msg.rawValue)
        self.backgroundView = bgView
    }
    
    /* for remove background view ( No data view ) */
    public func removeBackgroundView() {
        self.backgroundView = nil
    }
    
    /* for register get tableview actual height */
    public func getTableViewHeight(newHeight: @escaping (CGFloat) -> Void) {
        let _ = self.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            newHeight(height)
        }
    }
    
}

public enum NoData: String {
    
    case aca_empty = "ACA not found!"
    case hourly_event_empty = "Hourly events not found!"
    case todays_event_empty = "Todays events not found!"
    
}
