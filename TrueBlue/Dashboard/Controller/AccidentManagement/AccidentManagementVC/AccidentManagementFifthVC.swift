//
//  AccidentManagementFifthVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit
import Applio

class AccidentManagementFifthVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "LogSheetTVC")
    }
    
}

extension AccidentManagementFifthVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogSheetTVC") as? LogSheetTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
