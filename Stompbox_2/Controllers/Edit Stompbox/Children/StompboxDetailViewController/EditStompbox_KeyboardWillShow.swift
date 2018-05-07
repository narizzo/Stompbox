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
    tableView.contentInsetAdjustmentBehavior = .never
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillShow(_ notification:Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      tableView.isScrollEnabled = true
      
      let stackViewHeight = self.view.superview!.bounds.height
      let offset = self.tableView.bounds.height + keyboardSize.height - stackViewHeight
      tableView.contentInset = UIEdgeInsetsMake(0, 0, 116, 0)
    }
  }
  @objc func keyboardWillHide(_ notification:Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
  }
}
