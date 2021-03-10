//
//  Keyboard.swift
//  Cashier
//
//  Created by Trevor Piltch on 8/27/20.
//

import SwiftUI

// Function to hid the keyboard
func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

class Keyboard: ObservableObject {
    
    // For moving the keyboard
    @Published var currentHeight: CGFloat = 0
    
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                withAnimation {
                   currentHeight = keyboardSize.height
                }
            }
        }
    
    @objc func keyBoardWillHide(notification: Notification) {
            withAnimation {
               currentHeight = 0
            }
        }
}

