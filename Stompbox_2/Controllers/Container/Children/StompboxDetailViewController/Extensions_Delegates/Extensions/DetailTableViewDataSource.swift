//
//  TableViewDataSource.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if indexPath.row == 0 {
      cell = tableView.dequeueReusableCell(withIdentifier: Constants.stompboxCellReuseID, for: indexPath)
      if let stompboxCell = cell as? StompboxCell {
        // configure cell
        stompboxCell.isEditable = true
        stompboxCell.deltaButton.hide()

        // set UITextFieldDelegate
        stompboxCell.nameTextField.delegate = self // only need name because everything else is optional
        
        stompboxCell.nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
        stompboxCell.typeTextField.attributedPlaceholder = NSAttributedString(string: "type", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
        stompboxCell.manufacturerTextField.attributedPlaceholder = NSAttributedString(string: "manufacturer", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
        
        // load stompbox info if it exists
        if let stompboxToEdit = stompboxToEdit {
          stompboxCell.nameTextField.text = stompboxToEdit.name
          if let type = stompboxToEdit.type {
             stompboxCell.typeTextField.text = type
          }
          if let manufacturer = stompboxToEdit.manufacturer {
            stompboxCell.manufacturerTextField.text = manufacturer
          }

          stompboxCell.stompboxButton.delegate = stompboxButtonDelegate
        }
      }
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: Constants.simpleSettingReuseID, for: indexPath)
      if let simpleCell = cell as? SimpleSettingCell {
        simpleCell.backgroundColor = darkerGray
        if let stompboxToEdit = stompboxToEdit {
          simpleCell.knobLayoutStyle = stompboxToEdit.knobLayoutStyle
          
          // Load knobNameLabels into the SimpleSettingView
          if let settings = stompboxToEdit.settings {
            if let setting = settings.firstObject as? Setting {
              if let knobs = setting.knobs {
                var i: Int = 0
                while i < knobs.count && i < simpleCell.knobViews.count {
                  if let knob = knobs[i] as? Knob {
                    simpleCell.knobViews[i].knobNameLabel.text = knob.name
                  }
                  i += 1
                }
              }
            }
          }
        }
      }
    }
    return cell
  }
}