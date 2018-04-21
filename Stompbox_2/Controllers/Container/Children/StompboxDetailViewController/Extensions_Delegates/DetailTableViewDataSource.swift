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
        stompboxCell.isEditable = true
        stompboxCell.deltaButton.hide()
        if let stompboxToEdit = stompboxToEdit {
          stompboxCell.nameLabel.text = stompboxToEdit.name
          stompboxCell.typeLabel.text = stompboxToEdit.type
          stompboxCell.manufacturerLabel.text = stompboxToEdit.manufacturer
          stompboxCell.stompboxButton.delegate = stompboxButtonDelegate
        }
      }
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: Constants.simpleSettingReuseID, for: indexPath)
      if let simpleCell = cell as? SimpleSettingCell {
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
