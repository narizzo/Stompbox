//
//  SettingCollection_KeyboardWillShow.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 5/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension SettingCollectionViewController {
  
  NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
  
  NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  
}

func keyboardWillShow(_ notification:Notification) {
  
  if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
  }
}
func keyboardWillHide(_ notification:Notification) {
  
  if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
  }
}
