//
//  DetailTextFieldDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/22/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.returnKeyType = .done
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    saveKnobNames()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
