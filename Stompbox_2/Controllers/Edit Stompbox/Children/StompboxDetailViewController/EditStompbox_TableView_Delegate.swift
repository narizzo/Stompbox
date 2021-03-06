//
//  TableViewDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = tableView.bounds.height / 2.0
    if let cell = tableView.cellForRow(at: indexPath) as? SimpleSettingCell {
      cell.set(height) // set height so that the simpleSettingCell can redraw its content using the current height
    }
    return height
  }
}
