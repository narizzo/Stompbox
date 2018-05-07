//
//  EditStompbox_KeyboardWillShow.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 5/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController {
  
  func initializeKeyboardNotifications() {
    print("initializeKeyboardNotification")
    tableView.contentInsetAdjustmentBehavior = .never
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillShow(_ notification:Notification) {
    print("keyboard will show")
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      tableView.isScrollEnabled = true
//      print("tableView height: \(self.tableView.bounds.height)")
//      print("keyboard height: \(keyboardSize.height)")
//      print(self.view.bounds.height)
      
      let stackViewHeight = self.view.superview!.bounds.height
//      print("stackViewHeight: \(stackViewHeight)")
      let offset = self.tableView.bounds.height + keyboardSize.height - stackViewHeight
//      print("offset: \(offset)")
//      print("height of phone: \(UIScreen.main.bounds.height)")
      tableView.contentInset = UIEdgeInsetsMake(0, 0, 116, 0)
    }
  }
  @objc func keyboardWillHide(_ notification:Notification) {
    print("keyboardWillHide")
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      print("setting tableView contentInset back to normal")
      tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
  }
}
