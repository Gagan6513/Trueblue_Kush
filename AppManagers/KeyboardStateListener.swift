//
//  KeyboardStateListener.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import Foundation
import UIKit
//Diksha Rattan: This class checks if Keyboard is active or not
class KeyboardStateListener {
    static let shared = KeyboardStateListener()
    var isVisible = false
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleShow() {
        isVisible = true
    }
    
    @objc func handleHide() {
        isVisible = false
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self)
    }
}
