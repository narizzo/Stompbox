//
//  DetailTextFieldDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/22/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController: UITextFieldDelegate {
  
  // NOT CURRENTLY USED
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    if newText.isEmpty {
      doneBarButtonDelegate.disableDoneBarButton(self)
    } else {
      doneBarButtonDelegate.enableDoneBarButton(self)
    }
    return true
  }
}
