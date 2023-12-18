//
//  ActionType.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 16/04/23.
//

import Foundation

enum  ActionType {
  case ADD
  case DETAIL
  case UPDATE
    
    var Action : String {
        get {
            switch self {
            case .ADD:
                return "add"
            case .UPDATE:
                return "update"
            case .DETAIL:
                return "detail"
            }
        }
    }
}
