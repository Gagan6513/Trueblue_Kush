//
//  SearchProposedVehicleVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 07/09/21.
//

import UIKit
import DZNEmptyDataSet
//protocol SearchListDelegate {
//    func didSelectItem(selectedItem: String, selectedItemIndex : Int,listNameForSearch: String)
//}
class SearchListVC: UIViewController {
//    var searchListDelegate : SearchListDelegate! = nil
    var listNameForSearch = String()
    var listForSearch = [String]()
    var searchResults = [String]()
    var currentNotification = NSNotification.Name(String())
    @IBOutlet weak var screenTitleLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        searchResults = listForSearch
        screenTitleLbl.text = "Select \(listNameForSearch)"
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension SearchListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.SEARCH_LIST, for: indexPath as IndexPath) as! SearchListTblViewCell
        cell.selectionStyle = .none
//        if indexPath.row % 2 == 0 {
//            cell.contentView.backgroundColor = UIColor(named: AppColors.DISBLED_TAB_BACKGROUND)
//        } else {
//            cell.contentView.backgroundColor = .white
//        }
        cell.titleLbl.text = searchResults[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        searchListDelegate?.didSelectItem(selectedItem: searchResults[indexPath.row], selectedItemIndex: indexPath.row, listNameForSearch: listNameForSearch)
        var selectedIndex = Int()
        for i in 0...listForSearch.count-1 {
            if listForSearch[i] == searchResults[indexPath.row] {
                selectedIndex = i
            }
        }
        NotificationCenter.default.post(name: currentNotification, object: self, userInfo: ["selectedItem": searchResults[indexPath.row], "selectedIndex" : selectedIndex, "itemSelectedFromList" : listNameForSearch])
        dismiss(animated: true, completion: nil)
    }
    
}
extension SearchListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}

//extension SearchListVC : UISearchBarDelegate , UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchResults.removeAll()
//        searchResults = searchText.isEmpty ? listForSearch : listForSearch.filter{ $0.range(of: searchText, options: .caseInsensitive) != nil }
//        print(searchResults.count)
//        tblView.reloadData()
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//}

extension SearchListVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case searchTxtFld:
            searchResults.removeAll()
            print(searchTxtFld.text!)
            var searchText = textField.text! + string
            print(searchText)
            if string.isEmpty {//When user deletes characters
                searchText.removeLast()
            }
            if searchText.isEmpty {
                searchResults = listForSearch
            } else {
                print(listForSearch.count)
                
                for i in 0...listForSearch.count-1 {
                    print(listForSearch[i].lowercased())
                    print(searchTxtFld.text!.lowercased())
                    if listForSearch[i].lowercased().contains(searchText.lowercased()) {
                        searchResults.append(listForSearch[i])
                    }
                }
//                searchResults = textField.text!.isEmpty ? listForSearch : listForSearch.filter{ $0.range(of: textField.text!, options: .caseInsensitive) != nil }
            }
            print(searchResults.count)
            tblView.reloadData()
        default:
            print("Unkown textfield")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTxtFld:
            textField.resignFirstResponder()
        default:
            print("Unkown textfield")
        }
        return true
    }
}
